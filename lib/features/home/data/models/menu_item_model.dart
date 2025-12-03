import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/menu_item_entity.dart';

part 'menu_item_model.freezed.dart';
part 'menu_item_model.g.dart';

@freezed
class MenuItemModel with _$MenuItemModel {
  const MenuItemModel._();

  const factory MenuItemModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String category,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'is_available') required bool isAvailable,
  }) = _MenuItemModel;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  /// Convert to domain entity
  MenuItemEntity toEntity() {
    return MenuItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
    );
  }
}
