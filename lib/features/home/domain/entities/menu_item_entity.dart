import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item_entity.freezed.dart';

@freezed
class MenuItemEntity with _$MenuItemEntity {
  const factory MenuItemEntity({
    required String id,
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required bool isAvailable,
  }) = _MenuItemEntity;
}
