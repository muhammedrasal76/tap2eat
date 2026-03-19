import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../../config/constants/firebase_constants.dart';
import '../../../home/data/models/recent_order_model.dart';

abstract class DeliveryRemoteDataSource {
  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  });

  Future<String> acceptAssignment({
    required String assignmentId,
    required String orderId,
    required String userId,
  });

  Future<void> rejectAssignment({
    required String assignmentId,
    required String userId,
  });

  Future<void> updateDeliveryStatus({
    required String orderId,
    required String status,
  });

  Stream<RecentOrderModel> watchOrder(String orderId);

  Future<List<RecentOrderModel>> getDeliveryHistory(String userId);

  Future<bool> hasAvailableDeliveryStudent();
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;

  DeliveryRemoteDataSourceImpl({
    required this.firestore,
    required this.functions,
  });

  @override
  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.deliveryProfilesCollection)
          .doc(userId)
          .update({
        'is_online': isOnline,
        'online_since': isOnline ? FieldValue.serverTimestamp() : null,
      });
    } catch (e) {
      throw Exception('Failed to update online status: $e');
    }
  }

  @override
  Future<String> acceptAssignment({
    required String assignmentId,
    required String orderId,
    required String userId,
  }) async {
    try {
      final result =
          await functions.httpsCallable('acceptDeliveryAssignment').call({
        'assignmentId': assignmentId,
        'orderId': orderId,
        'userId': userId,
      });
      return result.data['orderId'] as String? ?? orderId;
    } catch (e) {
      throw Exception('Failed to accept assignment: $e');
    }
  }

  @override
  Future<void> rejectAssignment({
    required String assignmentId,
    required String userId,
  }) async {
    try {
      await functions.httpsCallable('rejectDeliveryAssignment').call({
        'assignmentId': assignmentId,
        'userId': userId,
      });
    } catch (e) {
      throw Exception('Failed to reject assignment: $e');
    }
  }

  @override
  Future<void> updateDeliveryStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.ordersCollection)
          .doc(orderId)
          .update({
        FirebaseConstants.orderStatus: status,
        FirebaseConstants.orderUpdatedAt: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update delivery status: $e');
    }
  }

  @override
  Stream<RecentOrderModel> watchOrder(String orderId) {
    return firestore
        .collection(FirebaseConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .where((snapshot) => snapshot.exists)
        .asyncMap((snapshot) async {
      final data = snapshot.data()!;
      data['id'] = snapshot.id;

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
    });
  }

  @override
  Future<List<RecentOrderModel>> getDeliveryHistory(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseConstants.ordersCollection)
          .where(FirebaseConstants.orderDeliveryStudentId, isEqualTo: userId)
          .get();

      final orders = <RecentOrderModel>[];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

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

      // Sort client-side by createdAt descending
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (e) {
      throw Exception('Failed to fetch delivery history: $e');
    }
  }

  @override
  Future<bool> hasAvailableDeliveryStudent() async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.deliveryProfilesCollection)
          .where('is_online', isEqualTo: true)
          .where('is_active', isEqualTo: true)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
