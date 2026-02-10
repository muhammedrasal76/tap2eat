current model menu item is a collection inside cantten model:


import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu_item_model.dart';

class CanteenModel {
  final String id;
  final String name;
  final List<MenuItemModel> menuItems;
  final int maxConcurrentOrders;
  final bool isActive;

  CanteenModel({
    required this.id,
    required this.name,
    required this.menuItems,
    required this.maxConcurrentOrders,
    required this.isActive,
  });

  factory CanteenModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    List<MenuItemModel> items = [];
    if (data['menu_items'] != null) {
      items = (data['menu_items'] as List)
          .map((item) => MenuItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return CanteenModel(
      id: doc.id,
      name: data['name'] ?? '',
      menuItems: items,
      maxConcurrentOrders: data['max_concurrent_orders'] ?? 10,
      isActive: data['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'menu_items': menuItems.map((item) => item.toFirestore()).toList(),
      'max_concurrent_orders': maxConcurrentOrders,
      'is_active': isActive,
    };
  }

  CanteenModel copyWith({
    String? id,
    String? name,
    List<MenuItemModel>? menuItems,
    int? maxConcurrentOrders,
    bool? isActive,
  }) {
    return CanteenModel(
      id: id ?? this.id,
      name: name ?? this.name,
      menuItems: menuItems ?? this.menuItems,
      maxConcurrentOrders: maxConcurrentOrders ?? this.maxConcurrentOrders,
      isActive: isActive ?? this.isActive,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  final bool isAvailable;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.isAvailable,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return MenuItemModel(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['image_url'],
      isAvailable: map['is_available'] ?? true,
    );
  }

  factory MenuItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItemModel.fromMap(data, id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_url': imageUrl,
      'is_available': isAvailable,
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
