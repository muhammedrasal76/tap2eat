// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canteen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CanteenModelImpl _$$CanteenModelImplFromJson(Map<String, dynamic> json) =>
    _$CanteenModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      menuItems: json['menu_items'] == null
          ? const []
          : _menuItemsFromJson(json['menu_items']),
      maxConcurrentOrders:
          (json['max_concurrent_orders'] as num?)?.toInt() ?? 10,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$CanteenModelImplToJson(_$CanteenModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'menu_items': _menuItemsToJson(instance.menuItems),
      'max_concurrent_orders': instance.maxConcurrentOrders,
      'is_active': instance.isActive,
    };
