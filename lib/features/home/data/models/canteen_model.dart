import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/canteen_entity.dart';
import 'menu_item_model.dart';

part 'canteen_model.freezed.dart';
part 'canteen_model.g.dart';

@freezed
class CanteenModel with _$CanteenModel {
  const CanteenModel._();

  const factory CanteenModel({
    required String id,
    required String name,
    @JsonKey(name: 'menu_items') required List<MenuItemModel> menuItems,
    @JsonKey(name: 'max_concurrent_orders') required int maxConcurrentOrders,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _CanteenModel;

  factory CanteenModel.fromJson(Map<String, dynamic> json) =>
      _$CanteenModelFromJson(json);

  /// Convert to domain entity
  CanteenEntity toEntity() {
    return CanteenEntity(
      id: id,
      name: name,
      menuItems: menuItems.map((item) => item.toEntity()).toList(),
      maxConcurrentOrders: maxConcurrentOrders,
      isActive: isActive,
      imageUrl: imageUrl,
    );
  }
}
