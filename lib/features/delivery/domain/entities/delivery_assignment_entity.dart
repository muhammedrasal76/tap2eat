import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_assignment_entity.freezed.dart';

@freezed
class DeliveryAssignmentEntity with _$DeliveryAssignmentEntity {
  const factory DeliveryAssignmentEntity({
    required String assignmentId,
    required String orderId,
    required String canteenName,
    required double totalAmount,
    required double deliveryFee,
    required int itemCount,
    required DateTime expiresAt,
  }) = _DeliveryAssignmentEntity;
}
