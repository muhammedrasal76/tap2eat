// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentOrderModelImpl _$$RecentOrderModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecentOrderModelImpl(
  id: json['id'] as String,
  canteenId: json['canteen_id'] as String,
  canteenName: json['canteen_name'] as String?,
  userId: json['user_id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['total_amount'] as num).toDouble(),
  fulfillmentSlot: _timestampToDateTime(json['fulfillment_slot']),
  fulfillmentType: json['fulfillment_type'] as String,
  status: json['status'] as String,
  deliveryStudentId: json['delivery_student_id'] as String?,
  deliveryFee: (json['delivery_fee'] as num?)?.toDouble(),
  createdAt: _timestampToDateTime(json['created_at']),
  updatedAt: _timestampToDateTime(json['updated_at']),
);

Map<String, dynamic> _$$RecentOrderModelImplToJson(
  _$RecentOrderModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'canteen_id': instance.canteenId,
  'canteen_name': instance.canteenName,
  'user_id': instance.userId,
  'items': instance.items,
  'total_amount': instance.totalAmount,
  'fulfillment_slot': _dateTimeToTimestamp(instance.fulfillmentSlot),
  'fulfillment_type': instance.fulfillmentType,
  'status': instance.status,
  'delivery_student_id': instance.deliveryStudentId,
  'delivery_fee': instance.deliveryFee,
  'created_at': _dateTimeToTimestamp(instance.createdAt),
  'updated_at': _dateTimeToTimestamp(instance.updatedAt),
};

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      menuItemId: json['menu_item_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  'menu_item_id': instance.menuItemId,
  'name': instance.name,
  'quantity': instance.quantity,
  'price': instance.price,
  'image_url': instance.imageUrl,
};
