const functions = require('firebase-functions');
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

    // C. CUTOFF TIME CHECK (FR 3.2.4) - Basic Implementation
    // (Actual implementation requires complex time/date logic not included here)
    
    // --- FINAL SUBMISSION ---

    const newOrder = {
        user_id: userId,
        canteen_id: canteenId,
        fulfillment_slot: fulfillmentSlot,
        fulfillment_type: fulfillmentType,
        items: items, // Expects an array of item objects
        total_cost: totalCost,
        status: 'pending',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        // Add delivery_student_id: null
    };

    const orderRef = await db.collection('orders').add(newOrder);

    return {
        orderId: orderRef.id,
        message: 'Order placed successfully and scheduled for ' + fulfillmentSlot
    };
});