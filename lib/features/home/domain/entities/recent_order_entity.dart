import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/constants/enum_values.dart';

part 'recent_order_entity.freezed.dart';

@freezed
class RecentOrderEntity with _$RecentOrderEntity {
  const factory RecentOrderEntity({
    required String id,
    required String canteenId,
    required String canteenName,
    required String userId,
    required List<OrderItemEntity> items,
    required double totalAmount,
    required DateTime fulfillmentSlot,
    required FulfillmentType fulfillmentType,
    required OrderStatus status,
    String? deliveryStudentId,
    double? deliveryFee,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RecentOrderEntity;
}

@freezed
class OrderItemEntity with _$OrderItemEntity {
  const factory OrderItemEntity({
    required String menuItemId,
    required String name,
    required int quantity,
    required double price,
    String? imageUrl,
  }) = _OrderItemEntity;
}
