import '../../../home/domain/entities/recent_order_entity.dart';

abstract class DeliveryRepository {
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

  Stream<RecentOrderEntity> watchOrder(String orderId);

  Future<List<RecentOrderEntity>> getDeliveryHistory(String userId);

  Future<bool> hasAvailableDeliveryStudent();
}
