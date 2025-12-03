import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/constants/enum_values.dart';
import '../../domain/entities/recent_order_entity.dart';

part 'recent_order_model.freezed.dart';
part 'recent_order_model.g.dart';

// Converter functions for Timestamp <-> DateTime
DateTime _timestampToDateTime(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return DateTime.now();
}

Timestamp _dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

@freezed
class RecentOrderModel with _$RecentOrderModel {
  const RecentOrderModel._();

  const factory RecentOrderModel({
    required String id,
    @JsonKey(name: 'canteen_id') required String canteenId,
    @JsonKey(name: 'canteen_name') String? canteenName,
    @JsonKey(name: 'user_id') required String userId,
    required List<OrderItemModel> items,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(
      name: 'fulfillment_slot',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime fulfillmentSlot,
    @JsonKey(name: 'fulfillment_type') required String fulfillmentType,
    required String status,
    @JsonKey(name: 'delivery_student_id') String? deliveryStudentId,
    @JsonKey(name: 'delivery_fee') double? deliveryFee,
    @JsonKey(
      name: 'created_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime updatedAt,
  }) = _RecentOrderModel;

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RecentOrderModelFromJson(json);

  /// Convert to domain entity
  RecentOrderEntity toEntity() {
    return RecentOrderEntity(
      id: id,
      canteenId: canteenId,
      canteenName: canteenName ?? 'Unknown Canteen',
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      fulfillmentSlot: fulfillmentSlot,
      fulfillmentType: FulfillmentTypeExtension.fromString(fulfillmentType),
      status: OrderStatusExtension.fromString(status),
      deliveryStudentId: deliveryStudentId,
      deliveryFee: deliveryFee,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    @JsonKey(name: 'menu_item_id') required String menuItemId,
    required String name,
    required int quantity,
    required double price,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  /// Convert to domain entity
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      menuItemId: menuItemId,
      name: name,
      quantity: quantity,
      price: price,
      imageUrl: imageUrl,
    );
  }
}
