import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_item_entity.dart';

part 'canteen_entity.freezed.dart';

@freezed
class CanteenEntity with _$CanteenEntity {
  const factory CanteenEntity({
    required String id,
    required String name,
    required List<MenuItemEntity> menuItems,
    required int maxConcurrentOrders,
    required bool isActive,
  }) = _CanteenEntity;
}
