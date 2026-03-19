import '../../../home/domain/entities/recent_order_entity.dart';

/// Repository interface for order operations
abstract class OrderRepository {
  /// Create a new order, returns the order ID
  Future<String> createOrder({
    required String canteenId,
    required String canteenName,
    required String userId,
    required List<OrderItemEntity> items,
    required double totalAmount,
    required DateTime fulfillmentSlot,
    required String fulfillmentType,
    required double deliveryFee,
  });

  /// Fetch all orders for a user, ordered by most recent
  Future<List<RecentOrderEntity>> getOrderHistory(String userId);

  /// Fetch a single order by ID
  Future<RecentOrderEntity> getOrderDetail(String orderId);

  /// Get count of active orders for a canteen
  Future<int> getActiveOrderCount(String canteenId);
}
