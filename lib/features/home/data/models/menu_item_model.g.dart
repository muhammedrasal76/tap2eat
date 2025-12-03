// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemModelImpl _$$MenuItemModelImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['image_url'] as String,
      isAvailable: json['is_available'] as bool,
    );

Map<String, dynamic> _$$MenuItemModelImplToJson(_$MenuItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'is_available': instance.isAvailable,
    };
