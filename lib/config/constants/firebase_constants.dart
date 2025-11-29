/// Firebase collection and field names
class FirebaseConstants {
  FirebaseConstants._();

  // Collection names (Data Model D1-D4)
  static const String usersCollection = 'users'; // D1
  static const String ordersCollection = 'orders'; // D2
  static const String settingsDocument = 'settings'; // D3 (single document)
  static const String canteensCollection = 'canteens'; // D4

  // User document fields (D1)
  static const String userRole = 'role';
  static const String userEmail = 'email';
  static const String userName = 'name';
  static const String userClassId = 'class_id'; // Students only
  static const String userDesignation = 'designation'; // Teachers only
  static const String userEarningsBalance = 'earnings_balance'; // Delivery students only
  static const String userCreatedAt = 'created_at';

  // Order document fields (D2)
  static const String orderCanteenId = 'canteen_id';
  static const String orderUserId = 'user_id';
  static const String orderItems = 'items';
  static const String orderTotalAmount = 'total_amount';
  static const String orderFulfillmentSlot = 'fulfillment_slot';
  static const String orderFulfillmentType = 'fulfillment_type';
  static const String orderStatus = 'status';
  static const String orderDeliveryStudentId = 'delivery_student_id'; // For delivery orders
  static const String orderDeliveryFee = 'delivery_fee';
  static const String orderCreatedAt = 'created_at';
  static const String orderUpdatedAt = 'updated_at';

  // Settings document fields (D3)
  static const String settingsBreakSlots = 'break_slots';
  static const String settingsOrderCutoffMinutes = 'order_cutoff_minutes';

  // Canteen document fields (D4)
  static const String canteenName = 'name';
  static const String canteenMenuItems = 'menu_items';
  static const String canteenMaxConcurrentOrders = 'max_concurrent_orders';
  static const String canteenIsActive = 'is_active';

  // Menu item fields (nested in D4)
  static const String menuItemId = 'id';
  static const String menuItemName = 'name';
  static const String menuItemDescription = 'description';
  static const String menuItemPrice = 'price';
  static const String menuItemCategory = 'category';
  static const String menuItemImageUrl = 'image_url';
  static const String menuItemIsAvailable = 'is_available';
}
