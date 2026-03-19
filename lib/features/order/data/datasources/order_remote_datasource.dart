import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../config/constants/firebase_constants.dart';
import '../../../home/data/models/recent_order_model.dart';

/// Remote data source for order operations (Firestore)
abstract class OrderRemoteDataSource {
  Future<String> createOrder(Map<String, dynamic> orderData);
  Future<List<RecentOrderModel>> getOrderHistory(String userId);
  Future<RecentOrderModel> getOrderDetail(String orderId);
  Future<int> getActiveOrderCount(String canteenId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<String> createOrder(Map<String, dynamic> orderData) async {
    try {
      final docRef = await firestore
          .collection(FirebaseConstants.ordersCollection)
          .add(orderData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<RecentOrderModel>> getOrderHistory(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.ordersCollection)
          .where(FirebaseConstants.orderUserId, isEqualTo: userId)
          .orderBy(FirebaseConstants.orderCreatedAt, descending: true)
          .get();

      final orders = <RecentOrderModel>[];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Fetch canteen name
        final canteenDoc = await firestore
            .collection(FirebaseConstants.canteensCollection)
            .doc(data[FirebaseConstants.orderCanteenId] as String)
            .get();

        if (canteenDoc.exists) {
          data['canteen_name'] =
              canteenDoc.data()?[FirebaseConstants.canteenName];
        }

        orders.add(RecentOrderModel.fromJson(data));
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch order history: $e');
    }
  }

  @override
  Future<RecentOrderModel> getOrderDetail(String orderId) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.ordersCollection)
          .doc(orderId)
          .get();

      if (!doc.exists) {
        throw Exception('Order not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id;

      // Fetch canteen name
      final canteenDoc = await firestore
          .collection(FirebaseConstants.canteensCollection)
          .doc(data[FirebaseConstants.orderCanteenId] as String)
          .get();

      if (canteenDoc.exists) {
        data['canteen_name'] =
            canteenDoc.data()?[FirebaseConstants.canteenName];
      }

      return RecentOrderModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch order detail: $e');
    }
  }

  @override
  Future<int> getActiveOrderCount(String canteenId) async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.ordersCollection)
          .where(FirebaseConstants.orderCanteenId, isEqualTo: canteenId)
          .where(FirebaseConstants.orderStatus,
              whereIn: ['pending', 'preparing', 'ready'])
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to fetch active order count: $e');
    }
  }
}
