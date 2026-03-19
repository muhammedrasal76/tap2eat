import '../../../home/domain/entities/recent_order_entity.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/delivery_remote_datasource.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource remoteDataSource;

  DeliveryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await remoteDataSource.updateOnlineStatus(
        userId: userId,
        isOnline: isOnline,
      );
    } catch (e) {
      throw Exception('Repository: Failed to update online status - $e');
    }
  }

  @override
  Future<String> acceptAssignment({
    required String assignmentId,
    required String orderId,
    required String userId,
  }) async {
    try {
      return await remoteDataSource.acceptAssignment(
        assignmentId: assignmentId,
        orderId: orderId,
        userId: userId,
      );
    } catch (e) {
      throw Exception('Repository: Failed to accept assignment - $e');
    }
  }

  @override
  Future<void> rejectAssignment({
    required String assignmentId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.rejectAssignment(
        assignmentId: assignmentId,
        userId: userId,
      );
    } catch (e) {
      throw Exception('Repository: Failed to reject assignment - $e');
    }
  }

  @override
  Future<void> updateDeliveryStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await remoteDataSource.updateDeliveryStatus(
        orderId: orderId,
        status: status,
      );
    } catch (e) {
      throw Exception('Repository: Failed to update delivery status - $e');
    }
  }

  @override
  Stream<RecentOrderEntity> watchOrder(String orderId) {
    return remoteDataSource
        .watchOrder(orderId)
        .map((model) => model.toEntity());
  }

  @override
  Future<List<RecentOrderEntity>> getDeliveryHistory(String userId) async {
    try {
      final models = await remoteDataSource.getDeliveryHistory(userId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get delivery history - $e');
    }
  }

  @override
  Future<bool> hasAvailableDeliveryStudent() async {
    return await remoteDataSource.hasAvailableDeliveryStudent();
  }
}
