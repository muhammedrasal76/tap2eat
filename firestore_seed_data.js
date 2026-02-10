/**
 * Firestore Seed Data Script
 *
 * This script initializes Firestore with sample data for testing the Tap2Eat app.
 * Run this script using Node.js after setting up Firebase Admin SDK credentials.
 *
 * Usage:
 * 1. Install dependencies: npm install firebase-admin
 * 2. Download your Firebase service account key from Firebase Console
 * 3. Set the path to your service account key in the script
 * 4. Run: node firestore_seed_data.js
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
// TODO: Replace with your service account key path
const serviceAccount = require('./path-to-your-service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedFirestore() {
  console.log('🌱 Starting Firestore seed...');

  try {
    // 1. Create Settings Document (D3)
    console.log('📝 Creating settings...');
    await db.collection('settings').doc('global').set({
      break_slots: [
        admin.firestore.Timestamp.fromDate(getTodayAt(10, 30)), // 10:30 AM
        admin.firestore.Timestamp.fromDate(getTodayAt(13, 0)),  // 1:00 PM
        admin.firestore.Timestamp.fromDate(getTodayAt(15, 30)), // 3:30 PM
      ],
      order_cutoff_minutes: 5,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Settings created');

    // 2. Create Canteens (D4)
    console.log('📝 Creating canteens...');

    // Create canteen document (without menu_items array)
    const canteen1Ref = await db.collection('canteens').add({
      name: 'The Grill',
      max_concurrent_orders: 50,
      is_active: true,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log(`✅ Canteen 1 created: ${canteen1Ref.id}`);

    // Add menu items as subcollection
    console.log('📝 Adding menu items to Canteen 1...');
    const menuItems1 = [
      {
        name: 'Burger Combo',
        description: 'Beef burger with fries and drink',
        price: 150.0,
        category: 'Burgers',
        image_url: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop',
        is_available: true,
      },
      {
        name: 'Grilled Chicken',
        description: 'Grilled chicken with vegetables',
        price: 180.0,
        category: 'Grilled',
        image_url: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=300&h=200&fit=crop',
        is_available: true,
      },
      {
        name: 'Chicken Wings',
        description: 'Crispy chicken wings with sauce',
        price: 120.0,
        category: 'Appetizers',
        image_url: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=300&h=200&fit=crop',
        is_available: true,
      },
    ];

    for (const item of menuItems1) {
      await canteen1Ref.collection('menu_items').add(item);
    }
    console.log(`✅ Added ${menuItems1.length} menu items to Canteen 1`);

    // Create canteen document (without menu_items array)
    const canteen2Ref = await db.collection('canteens').add({
      name: 'Pasta Paradise',
      max_concurrent_orders: 40,
      is_active: true,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log(`✅ Canteen 2 created: ${canteen2Ref.id}`);

    // Add menu items as subcollection
    console.log('📝 Adding menu items to Canteen 2...');
    const menuItems2 = [
      {
        name: 'Spaghetti Carbonara',
        description: 'Creamy pasta with bacon',
        price: 200.0,
        category: 'Pasta',
        image_url: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=300&h=200&fit=crop',
        is_available: true,
      },
      {
        name: 'Margherita Pizza',
        description: 'Classic tomato and mozzarella pizza',
        price: 250.0,
        category: 'Pizza',
        image_url: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&h=200&fit=crop',
        is_available: true,
      },
      {
        name: 'Caesar Salad',
        description: 'Fresh salad with Caesar dressing',
        price: 100.0,
        category: 'Salads',
        image_url: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop',
        is_available: true,
      },
    ];

    for (const item of menuItems2) {
      await canteen2Ref.collection('menu_items').add(item);
    }
    console.log(`✅ Added ${menuItems2.length} menu items to Canteen 2`);

    // Create canteen document (without menu_items array)
    const canteen3Ref = await db.collection('canteens').add({
      name: 'South Indian Corner',
      max_concurrent_orders: 60,
      is_active: true,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log(`✅ Canteen 3 created: ${canteen3Ref.id}`);

    // Add menu items as subcollection
    console.log('📝 Adding menu items to Canteen 3...');
    const menuItems3 = [
      {
        name: 'Masala Dosa',
        description: 'Crispy dosa with potato filling',
        price: 80.0,
        category: 'South Indian',
        image_url: 'https://images.unsplash.com/photo-1630383249896-424e482df921?w=300&h=200&fit=crop',
        is_available: true,
      },
      {
        name: 'Idli Sambar',
        description: 'Steamed idli with sambar and chutney',
        price: 60.0,
        category: 'South Indian',
        image_url: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300&h=200&fit=crop',
        is_available: true,
      },
      {
        name: 'Vada Sambar',
        description: 'Crispy vada with sambar',
        price: 50.0,
        category: 'South Indian',
        image_url: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=300&h=200&fit=crop',
        is_available: true,
      },
    ];

    for (const item of menuItems3) {
      await canteen3Ref.collection('menu_items').add(item);
    }
    console.log(`✅ Added ${menuItems3.length} menu items to Canteen 3`);

    // 3. Create Sample Users (D1)
    console.log('📝 Creating sample users...');

    // Student user
    await db.collection('users').doc('sample_student_user').set({
      role: 'student',
      email: 'student@example.com',
      name: 'John Student',
      class_id: 'CSE-3A',
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Sample student created');

    // Teacher user
    await db.collection('users').doc('sample_teacher_user').set({
      role: 'teacher',
      email: 'teacher@example.com',
      name: 'Dr. Sarah Teacher',
      designation: 'Professor',
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Sample teacher created');

    // Delivery student user
    await db.collection('users').doc('sample_delivery_user').set({
      role: 'delivery_student',
      email: 'delivery@example.com',
      name: 'Mike Delivery',
      class_id: 'CSE-2B',
      earnings_balance: 0,
      is_online: false,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Sample delivery student created');

    // 4. Create Sample Orders (D2) - Optional
    console.log('📝 Creating sample orders...');

    const now = new Date();
    const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);

    await db.collection('orders').add({
      canteen_id: canteen1Ref.id,
      user_id: 'sample_student_user',
      items: [
        {
          menu_item_id: 'item_001',
          name: 'Burger Combo',
          quantity: 1,
          price: 150.0,
          image_url: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop',
        },
      ],
      total_amount: 150.0,
      fulfillment_slot: admin.firestore.Timestamp.fromDate(twoHoursLater),
      fulfillment_type: 'pickup',
      status: 'pending',
      delivery_student_id: null,
      delivery_fee: 0,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('✅ Sample order created');

    console.log('');
    console.log('✨ Firestore seed completed successfully!');
    console.log('');
    console.log('📊 Summary:');
    console.log('  - Settings: 1 document');
    console.log('  - Canteens: 3 documents');
    console.log('  - Users: 3 documents');
    console.log('  - Orders: 1 document');
    console.log('');
    console.log('🔗 Canteen IDs:');
    console.log(`  - The Grill: ${canteen1Ref.id}`);
    console.log(`  - Pasta Paradise: ${canteen2Ref.id}`);
    console.log(`  - South Indian Corner: ${canteen3Ref.id}`);
    console.log('');
    console.log('👤 Test User IDs:');
    console.log('  - Student: sample_student_user');
    console.log('  - Teacher: sample_teacher_user');
    console.log('  - Delivery Student: sample_delivery_user');

  } catch (error) {
    console.error('❌ Error seeding Firestore:', error);
    throw error;
  } finally {
    // Close the admin app
    await admin.app().delete();
  }
}

/**
 * Helper function to get today's date at a specific time
 */
function getTodayAt(hour, minute) {
  const date = new Date();
  date.setHours(hour, minute, 0, 0);
  return date;
}

// Run the seed function
seedFirestore()
  .then(() => {
    console.log('✅ Script completed successfully');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
