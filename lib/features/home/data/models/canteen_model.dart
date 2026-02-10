import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/canteen_entity.dart';
import 'menu_item_model.dart';

part 'canteen_model.freezed.dart';
part 'canteen_model.g.dart';

// Custom converter for menu items list to handle null values
List<MenuItemModel> _menuItemsFromJson(dynamic json) {
  if (json == null) return [];
  if (json is! List) return [];

  return (json as List).asMap().entries.map((entry) {
    final index = entry.key;
    final item = entry.value;
    final itemMap = Map<String, dynamic>.from(item as Map<String, dynamic>);

    // Generate stable ID based on item name and index if missing
    if (!itemMap.containsKey('id') || itemMap['id'] == null || itemMap['id']?.toString().isEmpty == true) {
      final name = itemMap['name'] ?? 'item';
      final sanitizedName = name.toString().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
      itemMap['id'] = '${sanitizedName}_$index';
    }

    return MenuItemModel.fromJson(itemMap);
  }).toList();
}

List<Map<String, dynamic>> _menuItemsToJson(List<MenuItemModel> items) {
  return items.map((item) => item.toJson()).toList();
}

@freezed
class CanteenModel with _$CanteenModel {
  const CanteenModel._();

  const factory CanteenModel({
    required String id,
    required String name,
    @JsonKey(
      name: 'menu_items',
      fromJson: _menuItemsFromJson,
      toJson: _menuItemsToJson,
    )
    @Default([])
    List<MenuItemModel> menuItems,
    @JsonKey(name: 'max_concurrent_orders') @Default(10) int maxConcurrentOrders,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
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
    );
  }
}
