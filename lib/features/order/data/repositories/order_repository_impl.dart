import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../config/constants/firebase_constants.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

/// Implementation of OrderRepository
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
    try {
      final orderData = {
        FirebaseConstants.orderCanteenId: canteenId,
        FirebaseConstants.orderCanteenName: canteenName,
        FirebaseConstants.orderUserId: userId,
        FirebaseConstants.orderItems: items
            .map((item) => {
                  'id': item.menuItemId,
                  'name': item.name,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
        FirebaseConstants.orderTotalAmount: totalAmount,
        FirebaseConstants.orderFulfillmentSlot:
            Timestamp.fromDate(fulfillmentSlot),
        FirebaseConstants.orderFulfillmentType: fulfillmentType,
        FirebaseConstants.orderStatus: 'pending',
        FirebaseConstants.orderDeliveryFee: deliveryFee,
        if (deliveryAddress != null) 'delivery_address': deliveryAddress,
        FirebaseConstants.orderCreatedAt: FieldValue.serverTimestamp(),
        FirebaseConstants.orderUpdatedAt: FieldValue.serverTimestamp(),
      };

      return await remoteDataSource.createOrder(orderData);
    } catch (e) {
      throw Exception('Repository: Failed to create order - $e');
    }
  }

  @override
  Future<List<RecentOrderEntity>> getOrderHistory(String userId) async {
    try {
      final orderModels = await remoteDataSource.getOrderHistory(userId);
      return orderModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get order history - $e');
    }
  }

  @override
  Future<RecentOrderEntity> getOrderDetail(String orderId) async {
    try {
      final orderModel = await remoteDataSource.getOrderDetail(orderId);
      return orderModel.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get order detail - $e');
    }
  }

  @override
  Future<int> getActiveOrderCount(String canteenId) async {
    try {
      return await remoteDataSource.getActiveOrderCount(canteenId);
    } catch (e) {
      throw Exception('Repository: Failed to get active order count - $e');
    }
  }

  @override
  Stream<List<RecentOrderEntity>> watchOrderHistory(String userId) {
    return remoteDataSource
        .watchOrderHistory(userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Stream<RecentOrderEntity?> watchOrderDetail(String orderId) {
    return remoteDataSource
        .watchOrderDetail(orderId)
        .map((model) => model?.toEntity());
  }

  @override
  Future<Map<String, String>?> getDeliveryPersonInfo(String userId) =>
      remoteDataSource.getDeliveryPersonInfo(userId);
}
