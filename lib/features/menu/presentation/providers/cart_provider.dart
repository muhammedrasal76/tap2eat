import 'package:flutter/foundation.dart';
import '../../../home/domain/entities/canteen_entity.dart';
import '../../../home/domain/entities/menu_item_entity.dart';

/// Cart item with quantity
class CartItem {
  final MenuItemEntity menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;
}

/// Cart state management provider
class CartProvider with ChangeNotifier {
  CanteenEntity? _currentCanteen;
  final Map<String, CartItem> _items = {};

  // Getters
  CanteenEntity? get currentCanteen => _currentCanteen;
  Map<String, CartItem> get items => _items;
  List<CartItem> get cartItems => _items.values.toList();

  int get totalItems => _items.length;

  double get subtotal {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => 0.0; // TODO: Calculate based on fulfillment type

  double get total => subtotal + deliveryFee;

  bool get isEmpty => _items.isEmpty;

  /// Set the current canteen (clears cart if different canteen)
  void setCurrentCanteen(CanteenEntity canteen) {
    if (_currentCanteen?.id != canteen.id) {
      // Different canteen, clear cart
      _items.clear();
      _currentCanteen = canteen;
      notifyListeners();
    } else {
      _currentCanteen = canteen;
    }
  }

  /// Add item to cart
  void addItem(MenuItemEntity menuItem) {
    if (_items.containsKey(menuItem.id)) {
      // Item already in cart, increment quantity
      _items[menuItem.id]!.quantity++;
    } else {
      // New item, add to cart
      _items[menuItem.id] = CartItem(menuItem: menuItem, quantity: 1);
    }
    notifyListeners();
  }

  /// Remove one quantity of item from cart
  void removeItem(String menuItemId) {
    if (!_items.containsKey(menuItemId)) return;

    if (_items[menuItemId]!.quantity > 1) {
      _items[menuItemId]!.quantity--;
    } else {
      _items.remove(menuItemId);
    }
    notifyListeners();
  }

  /// Remove item completely from cart
  void deleteItem(String menuItemId) {
    _items.remove(menuItemId);
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(String menuItemId, int quantity) {
    if (!_items.containsKey(menuItemId)) return;

    if (quantity <= 0) {
      _items.remove(menuItemId);
    } else {
      _items[menuItemId]!.quantity = quantity;
    }
    notifyListeners();
  }

  /// Get quantity of specific item in cart
  int getItemQuantity(String menuItemId) {
    return _items[menuItemId]?.quantity ?? 0;
  }

  /// Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Check if specific item is in cart
  bool hasItem(String menuItemId) {
    return _items.containsKey(menuItemId);
  }
}
