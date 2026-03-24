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
    String? deliveryAddress,
  });

  /// Fetch all orders for a user, ordered by most recent
  Future<List<RecentOrderEntity>> getOrderHistory(String userId);

  /// Fetch a single order by ID
  Future<RecentOrderEntity> getOrderDetail(String orderId);

  /// Get count of active orders for a canteen
  Future<int> getActiveOrderCount(String canteenId);

  /// Stream all orders for a user, updating in real time
  Stream<List<RecentOrderEntity>> watchOrderHistory(String userId);

  /// Stream a single order document, updating in real time
  Stream<RecentOrderEntity?> watchOrderDetail(String orderId);

  /// Fetch name and phone of a delivery person from users collection
  Future<Map<String, String>?> getDeliveryPersonInfo(String userId);

  /// Cancel a pending order by setting its status to cancelled
  Future<void> cancelOrder(String orderId);
}
