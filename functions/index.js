const functions = require('firebase-functions');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');

// Initialize the Firebase Admin SDK to allow privileged access to Firestore
admin.initializeApp();
const db = admin.firestore();

// --- P2.0: Order Scheduling and Throttling Function ---
// This function is called directly by the mobile app when a user places an order.
// It executes the core policy checks (Throttling & Delivery Time Lock).

exports.placeOrder = functions.https.onCall(async (data, context) => {
    const { canteenId, fulfillmentSlot, fulfillmentType, items, totalCost } = data;
    const userId = context.auth.uid; // User ID is guaranteed if authenticated

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    // 1. Fetch User Role & Canteen Limits simultaneously for efficiency
    const [userDoc, canteenDoc, settingsDoc] = await Promise.all([
        db.collection('users').doc(userId).get(),
        db.collection('canteens').doc(canteenId).get(),
        db.collection('settings').doc('global').get()
    ]);

    const user = userDoc.data();
    const canteen = canteenDoc.data();
    const settings = settingsDoc.data();

    if (!canteen || !canteen.max_concurrent_orders) {
        throw new functions.https.HttpsError('failed-precondition', 'Canteen data not available.');
    }

    // --- POLICY ENFORCEMENT ---

    // A. DELIVERY POLICY CHECK (FR 3.2.3 & FR 3.2.4)
    if (fulfillmentType === 'delivery') {
        if (user.role !== 'teacher') {
            throw new functions.https.HttpsError('permission-denied', 'Delivery is restricted to Teachers.');
        }

        const isBreakSlot = settings.break_slots.some(slot => slot.label === fulfillmentSlot);
        if (!isBreakSlot) {
            throw new functions.https.HttpsError('permission-denied', 'Delivery is only allowed during official break slots.');
        }
    }

    // B. THROTTLING CHECK (FR 3.2.2)
    const maxOrders = canteen.max_concurrent_orders;

    // Count active orders for the requested slot at this canteen
    const activeOrdersSnapshot = await db.collection('orders')
        .where('canteen_id', '==', canteenId)
        .where('fulfillment_slot', '==', fulfillmentSlot)
        .where('status', 'in', ['pending', 'preparing', 'ready', 'assigned'])
        .get();

    const currentActiveOrders = activeOrdersSnapshot.size;

    if (currentActiveOrders >= maxOrders) {
        throw new functions.https.HttpsError('resource-exhausted', `The slot ${fulfillmentSlot} is currently full. Please choose another time.`);
    }

    // C. CUTOFF TIME CHECK (FR 3.2.4 & 4.1.4)
    // Orders cannot be placed for time slots beginning within 5 minutes
    const cutoffMinutes = settings.order_cutoff_minutes || 5;

    // Parse fulfillment slot - expecting Timestamp from client
    const slotTime = new admin.firestore.Timestamp(fulfillmentSlot.seconds, fulfillmentSlot.nanoseconds).toDate();
    const now = new Date();
    const timeDiffMinutes = (slotTime - now) / (1000 * 60);

    if (timeDiffMinutes < cutoffMinutes) {
        throw new functions.https.HttpsError(
            'failed-precondition',
            `Orders must be placed at least ${cutoffMinutes} minutes before the slot starts.`
        );
    }

    // --- FINAL SUBMISSION ---

    // Calculate delivery fee
    const deliveryFee = fulfillmentType === 'delivery' ? 20 : 0;

    const newOrder = {
        user_id: userId,
        canteen_id: canteenId,
        fulfillment_slot: admin.firestore.Timestamp.fromDate(slotTime),
        fulfillment_type: fulfillmentType,
        items: items, // Expects an array of item objects
        total_amount: totalCost,
        delivery_fee: deliveryFee,
        delivery_student_id: null, // Initialize as null, assigned later if delivery
        status: 'pending',
        created_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    };

    const orderRef = await db.collection('orders').add(newOrder);

    // Create audit log
    await db.collection('audit_logs').add({
        action: 'order_placed',
        user_id: userId,
        order_id: orderRef.id,
        canteen_id: canteenId,
        fulfillment_type: fulfillmentType,
        total_amount: totalCost,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
        orderId: orderRef.id,
        message: 'Order placed successfully and scheduled for ' + fulfillmentSlot
    };
});

// --- P2.1: Cancel Order Function ---
// Allows users to cancel their own pending or preparing orders

exports.cancelOrder = functions.https.onCall(async (data, context) => {
    const { orderId } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const orderRef = db.collection('orders').doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Order not found.');
    }

    const order = orderDoc.data();

    // Authorization: Users can only cancel their own orders
    if (order.user_id !== userId) {
        throw new functions.https.HttpsError(
            'permission-denied',
            'You can only cancel your own orders.'
        );
    }

    // Business rule: Only pending/preparing orders can be cancelled
    if (!['pending', 'preparing'].includes(order.status)) {
        throw new functions.https.HttpsError(
            'failed-precondition',
            `Cannot cancel order with status: ${order.status}. Only pending or preparing orders can be cancelled.`
        );
    }

    // Update order status
    await orderRef.update({
        status: 'cancelled',
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'order_cancelled',
        user_id: userId,
        order_id: orderId,
        previous_status: order.status,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: 'Order cancelled successfully.' };
});

// --- P2.2: Update Order Status Function (Canteen Admin) ---
// Allows canteen admins to update order status (preparing → ready, etc.)

exports.updateOrderStatus = functions.https.onCall(async (data, context) => {
    const { orderId, newStatus } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    // Verify user is canteen admin or master admin
    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (!['canteen_admin', 'master_admin'].includes(user.role)) {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Insufficient permissions. Only canteen or master admins can update orders.'
        );
    }

    const orderRef = db.collection('orders').doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Order not found.');
    }

    const order = orderDoc.data();

    // RBAC: Canteen admin can only update their own canteen's orders
    if (user.role === 'canteen_admin' && order.canteen_id !== user.canteen_id) {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Access denied. You can only update orders for your canteen.'
        );
    }

    // Validate status transition
    const validTransitions = {
        'pending': ['preparing', 'cancelled'],
        'preparing': ['ready', 'cancelled'],
        'ready': ['completed'], // Pickup orders
        'assigned': ['delivering'],
        'delivering': ['delivered'],
        'delivered': ['completed'],
    };

    if (!validTransitions[order.status]?.includes(newStatus)) {
        throw new functions.https.HttpsError(
            'failed-precondition',
            `Invalid status transition from ${order.status} to ${newStatus}.`
        );
    }

    // Update order
    await orderRef.update({
        status: newStatus,
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'order_status_updated',
        admin_id: userId,
        order_id: orderId,
        old_status: order.status,
        new_status: newStatus,
        canteen_id: order.canteen_id,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: `Order status updated to ${newStatus}.` };
});

// --- P2.3: Get Orders by Canteen (Admin Dashboard) ---
// Fetch orders for canteen admin dashboard, sorted by fulfillment_slot (PRD US-CA2)

exports.getOrdersByCanteen = functions.https.onCall(async (data, context) => {
    const { canteenId, status, limit = 50 } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    // Verify canteen admin access
    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    // RBAC: Canteen admin can only access their own canteen's orders
    if (user.role === 'canteen_admin' && user.canteen_id !== canteenId) {
        throw new functions.https.HttpsError('permission-denied', 'Access denied.');
    }

    if (!['canteen_admin', 'master_admin'].includes(user.role)) {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Only canteen or master admins can view canteen orders.'
        );
    }

    let query = db.collection('orders')
        .where('canteen_id', '==', canteenId);

    if (status) {
        query = query.where('status', '==', status);
    }

    // PRD Requirement US-CA2: Sort by fulfillment_slot, NOT order placement time
    query = query.orderBy('fulfillment_slot', 'asc').limit(limit);

    const snapshot = await query.get();
    const orders = [];

    snapshot.forEach(doc => {
        orders.push({ id: doc.id, ...doc.data() });
    });

    return { orders };
});

// --- P2.4: Get Orders by User (Mobile App) ---
// Fetch user's order history

exports.getOrdersByUser = functions.https.onCall(async (data, context) => {
    const { limit = 20 } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const query = db.collection('orders')
        .where('user_id', '==', userId)
        .orderBy('created_at', 'desc')
        .limit(limit);

    const snapshot = await query.get();
    const orders = [];

    snapshot.forEach(doc => {
        orders.push({ id: doc.id, ...doc.data() });
    });

    return { orders };
});

// ====================================================================
// DELIVERY SYSTEM FUNCTIONS (P3.0 & P3.1 Logic)
// ====================================================================

// --- P3.1: Toggle Delivery Student Online Status ---
// Delivery students go online/offline (Time Lock Policy enforced - FR 4.2.1)

exports.toggleDeliveryOnline = functions.https.onCall(async (data, context) => {
    const { goOnline } = data; // boolean
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (user.role !== 'delivery_student') {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Only delivery students can use this feature.'
        );
    }

    // TIME LOCK POLICY ENFORCEMENT (PRD FR 4.2.1, US-DS1)
    // Backend validates server time, not client time
    const settingsDoc = await db.collection('settings').doc('global').get();
    const settings = settingsDoc.data();
    const breakSlots = settings.break_slots || [];

    const now = new Date();
    let isDuringBreak = false;

    // Check if current time is within any break slot
    for (const slot of breakSlots) {
        const slotTime = slot.toDate(); // Timestamp to Date
        const slotEnd = new Date(slotTime.getTime() + 60 * 60 * 1000); // Assume 1 hour duration

        if (now >= slotTime && now <= slotEnd) {
            isDuringBreak = true;
            break;
        }
    }

    // Reject if trying to go online outside break times
    if (goOnline && !isDuringBreak) {
        throw new functions.https.HttpsError(
            'failed-precondition',
            'You can only go online during official break times. Check the schedule and try again.'
        );
    }

    // Update user status
    await db.collection('users').doc(userId).update({
        is_online: goOnline,
        last_status_change: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'delivery_status_changed',
        user_id: userId,
        is_online: goOnline,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
        success: true,
        is_online: goOnline,
        message: goOnline ? 'You are now online for deliveries.' : 'You are now offline.'
    };
});

// --- P3.2: Assign Delivery Orders (Scheduled Function) ---
// Runs every minute, assigns delivery orders at fulfillment_slot start time (FR 4.2.2)

exports.assignDelivery = onSchedule('every 1 minutes', async (event) => {
    const now = admin.firestore.Timestamp.now();
    const oneMinuteAgo = admin.firestore.Timestamp.fromMillis(
        now.toMillis() - 60000
    );

    // Find delivery orders with fulfillment_slot in the past minute, status 'ready'
    const ordersSnapshot = await db.collection('orders')
        .where('fulfillment_type', '==', 'delivery')
        .where('status', '==', 'ready')
        .where('fulfillment_slot', '>=', oneMinuteAgo)
        .where('fulfillment_slot', '<=', now)
        .get();

    if (ordersSnapshot.empty) {
        console.log('No delivery orders to assign at this time.');
        return null;
    }

    // Find online delivery students
    const deliveryStudentsSnapshot = await db.collection('users')
        .where('role', '==', 'delivery_student')
        .where('is_online', '==', true)
        .get();

    if (deliveryStudentsSnapshot.empty) {
        console.log('No delivery students online. Orders will fall back to pickup.');
        return null;
    }

    const onlineStudents = [];
    deliveryStudentsSnapshot.forEach(doc => {
        onlineStudents.push({ id: doc.id, ...doc.data() });
    });

    // Assign orders (simple round-robin distribution)
    const batch = db.batch();
    let studentIndex = 0;

    ordersSnapshot.forEach(doc => {
        const order = doc.data();
        const student = onlineStudents[studentIndex % onlineStudents.length];

        // Update order with assignment
        batch.update(doc.ref, {
            status: 'assigned',
            delivery_student_id: student.id,
            assignment_time: admin.firestore.FieldValue.serverTimestamp(),
            updated_at: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Audit log
        const auditRef = db.collection('audit_logs').doc();
        batch.set(auditRef, {
            action: 'delivery_assigned',
            order_id: doc.id,
            delivery_student_id: student.id,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        // TODO: Send FCM notification to delivery student with earning amount

        studentIndex++;
    });

    await batch.commit();
    console.log(`Assigned ${ordersSnapshot.size} delivery orders.`);
    return null;
});

// --- P3.3: Delivery Fallback (Scheduled Function) ---
// Runs every minute, converts unaccepted deliveries to pickup after 5 minutes (FR 4.2.3)

exports.deliveryFallback = onSchedule('every 1 minutes', async (event) => {
    const now = admin.firestore.Timestamp.now();
    const fiveMinutesAgo = admin.firestore.Timestamp.fromMillis(
        now.toMillis() - 5 * 60000
    );

    // Find delivery orders assigned >5 minutes ago, still in 'assigned' status
    const ordersSnapshot = await db.collection('orders')
        .where('fulfillment_type', '==', 'delivery')
        .where('status', '==', 'assigned')
        .where('assignment_time', '<=', fiveMinutesAgo)
        .get();

    if (ordersSnapshot.empty) {
        console.log('No delivery orders need fallback.');
        return null;
    }

    const batch = db.batch();

    ordersSnapshot.forEach(doc => {
        const order = doc.data();

        // PRD Requirement: Fallback to pickup (US-T4)
        batch.update(doc.ref, {
            status: 'ready', // Back to ready for pickup
            fulfillment_type: 'pickup', // Override to pickup
            delivery_student_id: null,
            delivery_fee: 0, // Remove delivery fee
            fallback_reason: 'No delivery student accepted within 5 minutes',
            updated_at: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Audit log
        const auditRef = db.collection('audit_logs').doc();
        batch.set(auditRef, {
            action: 'delivery_fallback',
            order_id: doc.id,
            original_delivery_student: order.delivery_student_id,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        // TODO: Send FCM notification to teacher (US-T4)
    });

    await batch.commit();
    console.log(`Applied fallback to ${ordersSnapshot.size} delivery orders.`);
    return null;
});

// --- P3.4: Accept Delivery ---
// Delivery student accepts assigned order (within 5-minute window)

exports.acceptDelivery = functions.https.onCall(async (data, context) => {
    const { orderId } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (user.role !== 'delivery_student') {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Only delivery students can accept orders.'
        );
    }

    const orderRef = db.collection('orders').doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Order not found.');
    }

    const order = orderDoc.data();

    // Validation: Order must be assigned to this student
    if (order.status !== 'assigned' || order.delivery_student_id !== userId) {
        throw new functions.https.HttpsError(
            'failed-precondition',
            'Order cannot be accepted. Either it is not assigned to you or already accepted.'
        );
    }

    // Accept delivery
    await orderRef.update({
        status: 'delivering',
        acceptance_time: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'delivery_accepted',
        delivery_student_id: userId,
        order_id: orderId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: 'Delivery accepted. Please proceed to pickup and deliver.' };
});

// --- P3.5: Confirm Delivery Completion ---
// Delivery student confirms delivery, earnings auto-increment (FR 4.2.4)

exports.confirmDelivery = functions.https.onCall(async (data, context) => {
    const { orderId } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const orderRef = db.collection('orders').doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Order not found.');
    }

    const order = orderDoc.data();

    // Validation: Only assigned delivery student can confirm
    if (order.delivery_student_id !== userId || order.status !== 'delivering') {
        throw new functions.https.HttpsError(
            'failed-precondition',
            'Cannot confirm this delivery. You are not assigned to this order.'
        );
    }

    // Update order to delivered
    await orderRef.update({
        status: 'delivered',
        delivered_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // PRD FR 4.2.4: Automatically increment earnings balance
    const userRef = db.collection('users').doc(userId);
    await userRef.update({
        earnings_balance: admin.firestore.FieldValue.increment(order.delivery_fee),
    });

    // Create earnings record
    await db.collection('earnings').add({
        delivery_student_id: userId,
        order_id: orderId,
        amount: order.delivery_fee,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'delivery_confirmed',
        delivery_student_id: userId,
        order_id: orderId,
        earnings: order.delivery_fee,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
        success: true,
        earnings_added: order.delivery_fee,
        message: `Delivery confirmed! ₹${order.delivery_fee} added to your earnings.`
    };
});

// --- P3.6: Get Earnings History ---
// Fetch delivery student's earnings history (US-DS3)

exports.getEarningsHistory = functions.https.onCall(async (data, context) => {
    const { limit = 50 } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const query = db.collection('earnings')
        .where('delivery_student_id', '==', userId)
        .orderBy('timestamp', 'desc')
        .limit(limit);

    const snapshot = await query.get();
    const earnings = [];

    snapshot.forEach(doc => {
        earnings.push({ id: doc.id, ...doc.data() });
    });

    // Get current balance from user document
    const userDoc = await db.collection('users').doc(userId).get();
    const balance = userDoc.data().earnings_balance || 0;

    return { earnings, total_balance: balance };
});

// ====================================================================
// ADMIN OPERATIONS FUNCTIONS (P4.0 Logic)
// ====================================================================

// --- P4.1: Update Menu Items ---
// Canteen admin updates menu (FR 4.3.1)

exports.updateMenuItems = functions.https.onCall(async (data, context) => {
    const { canteenId, menuItems } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    // RBAC: Canteen admin can only update their own canteen
    if (user.role === 'canteen_admin' && user.canteen_id !== canteenId) {
        throw new functions.https.HttpsError('permission-denied', 'Access denied. You can only update your own canteen.');
    }

    if (!['canteen_admin', 'master_admin'].includes(user.role)) {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Insufficient permissions.'
        );
    }

    // Basic validation for menu items
    if (!Array.isArray(menuItems)) {
        throw new functions.https.HttpsError('invalid-argument', 'Menu items must be an array.');
    }

    // Update menu
    await db.collection('canteens').doc(canteenId).update({
        menu_items: menuItems,
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'menu_updated',
        admin_id: userId,
        canteen_id: canteenId,
        items_count: menuItems.length,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: 'Menu updated successfully.' };
});

// --- P4.2: Update Throttle Limit ---
// Canteen admin adjusts max_concurrent_orders (US-CA1)

exports.updateThrottleLimit = functions.https.onCall(async (data, context) => {
    const { canteenId, maxConcurrentOrders } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    // RBAC enforcement
    if (user.role === 'canteen_admin' && user.canteen_id !== canteenId) {
        throw new functions.https.HttpsError('permission-denied', 'Access denied.');
    }

    if (!['canteen_admin', 'master_admin'].includes(user.role)) {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Insufficient permissions.'
        );
    }

    // Validation
    if (typeof maxConcurrentOrders !== 'number' || maxConcurrentOrders < 1) {
        throw new functions.https.HttpsError(
            'invalid-argument',
            'Invalid limit value. Must be a number greater than 0.'
        );
    }

    await db.collection('canteens').doc(canteenId).update({
        max_concurrent_orders: maxConcurrentOrders,
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'throttle_limit_updated',
        admin_id: userId,
        canteen_id: canteenId,
        new_limit: maxConcurrentOrders,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: `Throttle limit updated to ${maxConcurrentOrders}.` };
});

// --- P4.3: Update Break Slots ---
// Master admin updates global break_slots (FR 4.3.2)

exports.updateBreakSlots = functions.https.onCall(async (data, context) => {
    const { breakSlots } = data; // Array of Timestamps
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (user.role !== 'master_admin') {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Only Master Admin can update break slots.'
        );
    }

    // Validation
    if (!Array.isArray(breakSlots)) {
        throw new functions.https.HttpsError(
            'invalid-argument',
            'Break slots must be an array.'
        );
    }

    await db.collection('settings').doc('global').update({
        break_slots: breakSlots,
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
        action: 'break_slots_updated',
        admin_id: userId,
        slots_count: breakSlots.length,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: 'Break slots updated successfully.' };
});

// --- P4.4: Get Audit Logs ---
// Master admin retrieves audit logs (NFR 5.1.3)

exports.getAuditLogs = functions.https.onCall(async (data, context) => {
    const { limit = 100, action, startDate } = data;
    const userId = context.auth.uid;

    if (!userId) {
        throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (user.role !== 'master_admin') {
        throw new functions.https.HttpsError(
            'permission-denied',
            'Only Master Admin can view audit logs.'
        );
    }

    let query = db.collection('audit_logs')
        .orderBy('timestamp', 'desc')
        .limit(limit);

    if (action) {
        query = query.where('action', '==', action);
    }

    if (startDate) {
        query = query.where('timestamp', '>=', startDate);
    }

    const snapshot = await query.get();
    const logs = [];

    snapshot.forEach(doc => {
        logs.push({ id: doc.id, ...doc.data() });
    });

    return { logs };
});