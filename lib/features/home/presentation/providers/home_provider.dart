import 'package:flutter/foundation.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/time_lock_helper.dart';
import '../../domain/entities/canteen_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/entities/recent_order_entity.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/get_canteens_usecase.dart';
import '../../domain/usecases/get_recent_orders_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/search_canteens_usecase.dart';

/// Home screen state management provider
class HomeProvider with ChangeNotifier {
  final GetCanteensUseCase getCanteensUseCase;
  final GetRecentOrdersUseCase getRecentOrdersUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final SearchCanteensUseCase searchCanteensUseCase;

  // Dummy data flag - set to false when Firebase is ready
  static const bool _useDummyData = true;

  HomeProvider({
    required this.getCanteensUseCase,
    required this.getRecentOrdersUseCase,
    required this.getSettingsUseCase,
    required this.searchCanteensUseCase,
  });

  // State
  List<CanteenEntity> _canteens = [];
  List<RecentOrderEntity> _recentOrders = [];
  SettingsEntity? _settings;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;

  // Getters
  List<CanteenEntity> get canteens => _canteens;
  List<RecentOrderEntity> get recentOrders => _recentOrders;
  SettingsEntity? get settings => _settings;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;

  /// Check if "Go Online" button should be visible (delivery students only during break time)
  bool shouldShowGoOnlineButton(UserRole? userRole) {
    if (userRole != UserRole.deliveryStudent) return false;
    if (_settings == null) return false;

    return TimeLockHelper.isWithinBreakTime(
      DateTime.now(),
      _settings!.breakSlots,
    );
  }

  /// Initialize home screen data
  Future<void> initialize(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_useDummyData) {
        // Use dummy data for testing UI
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        _canteens = _getDummyCanteens();
        _recentOrders = _getDummyRecentOrders();
        _settings = _getDummySettings();
      } else {
        // Fetch all data in parallel from Firebase
        await Future.wait([
          _fetchCanteens(),
          _fetchRecentOrders(userId),
          _fetchSettings(),
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load data: ${e.toString()}';
      debugPrint('HomeProvider initialization error: $e');
      notifyListeners();
    }
  }

  /// Fetch canteens
  Future<void> _fetchCanteens() async {
    try {
      _canteens = await getCanteensUseCase(NoParams());
    } catch (e) {
      throw Exception('Failed to fetch canteens: $e');
    }
  }

  /// Fetch recent orders
  Future<void> _fetchRecentOrders(String userId) async {
    try {
      _recentOrders = await getRecentOrdersUseCase(
        GetRecentOrdersParams(userId: userId),
      );
    } catch (e) {
      // Don't throw - recent orders are optional
      _recentOrders = [];
      debugPrint('Failed to fetch recent orders: $e');
    }
  }

  /// Fetch settings
  Future<void> _fetchSettings() async {
    try {
      _settings = await getSettingsUseCase(NoParams());
    } catch (e) {
      throw Exception('Failed to fetch settings: $e');
    }
  }

  /// Search canteens by query
  Future<void> searchCanteens(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      // Reset to all canteens
      if (_useDummyData) {
        _canteens = _getDummyCanteens();
      } else {
        await _fetchCanteens();
      }
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      if (_useDummyData) {
        // Filter dummy data locally
        final allCanteens = _getDummyCanteens();
        _canteens = allCanteens.where((canteen) {
          final lowercaseQuery = query.toLowerCase();
          if (canteen.name.toLowerCase().contains(lowercaseQuery)) {
            return true;
          }
          return canteen.menuItems.any((item) =>
              item.name.toLowerCase().contains(lowercaseQuery) ||
              item.category.toLowerCase().contains(lowercaseQuery));
        }).toList();
      } else {
        // Real search via use case
        _canteens = await searchCanteensUseCase(
          SearchCanteensParams(query: query),
        );
      }

      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _isSearching = false;
      _errorMessage = 'Search failed';
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refresh(String userId) async {
    await initialize(userId);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ==================== Dummy Data Methods ====================

  /// Get dummy canteens for UI testing
  List<CanteenEntity> _getDummyCanteens() {
    return [
      CanteenEntity(
        id: 'canteen_001',
        name: 'The Grill',
        isActive: true,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=200&fit=crop',
        maxConcurrentOrders: 50,
        menuItems: [
          MenuItemEntity(
            id: 'item_001',
            name: 'Burger Combo',
            description: 'Beef burger with fries and drink',
            price: 150.0,
            category: 'Burgers',
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop',
            isAvailable: true,
          ),
          MenuItemEntity(
            id: 'item_002',
            name: 'Grilled Chicken',
            description: 'Grilled chicken with vegetables',
            price: 180.0,
            category: 'Grilled',
            imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=300&h=200&fit=crop',
            isAvailable: true,
          ),
          MenuItemEntity(
            id: 'item_003',
            name: 'Chicken Wings',
            description: 'Crispy chicken wings with sauce',
            price: 120.0,
            category: 'Appetizers',
            imageUrl: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=300&h=200&fit=crop',
            isAvailable: true,
          ),
        ],
      ),
      CanteenEntity(
        id: 'canteen_002',
        name: 'Pasta Paradise',
        isActive: true,
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=200&fit=crop',
        maxConcurrentOrders: 40,
        menuItems: [
          MenuItemEntity(
            id: 'item_004',
            name: 'Spaghetti Carbonara',
            description: 'Creamy pasta with bacon',
            price: 200.0,
            category: 'Pasta',
            imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=300&h=200&fit=crop',
            isAvailable: true,
          ),
          MenuItemEntity(
            id: 'item_005',
            name: 'Margherita Pizza',
            description: 'Classic tomato and mozzarella pizza',
            price: 250.0,
            category: 'Pizza',
            imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&h=200&fit=crop',
            isAvailable: true,
          ),
          MenuItemEntity(
            id: 'item_006',
            name: 'Caesar Salad',
            description: 'Fresh salad with Caesar dressing',
            price: 100.0,
            category: 'Salads',
            imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop',
            isAvailable: true,
          ),
        ],
      ),
    ];
  }

  /// Get dummy recent orders for UI testing
  List<RecentOrderEntity> _getDummyRecentOrders() {
    final now = DateTime.now();
    return [
      RecentOrderEntity(
        id: 'order_001',
        canteenId: 'canteen_001',
        canteenName: 'The Grill',
        userId: 'dummy_user_id',
        items: [
          OrderItemEntity(
            menuItemId: 'item_001',
            name: 'Burger Combo',
            quantity: 2,
            price: 150.0,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop',
          ),
        ],
        totalAmount: 300.0,
        fulfillmentSlot: now.add(const Duration(hours: 2)),
        fulfillmentType: FulfillmentType.pickup,
        status: OrderStatus.completed,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      RecentOrderEntity(
        id: 'order_002',
        canteenId: 'canteen_002',
        canteenName: 'Pasta Paradise',
        userId: 'dummy_user_id',
        items: [
          OrderItemEntity(
            menuItemId: 'item_004',
            name: 'Spaghetti Carbonara',
            quantity: 1,
            price: 200.0,
            imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=300&h=200&fit=crop',
          ),
        ],
        totalAmount: 200.0,
        fulfillmentSlot: now.add(const Duration(hours: 1)),
        fulfillmentType: FulfillmentType.pickup,
        status: OrderStatus.completed,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      RecentOrderEntity(
        id: 'order_003',
        canteenId: 'canteen_001',
        canteenName: 'The Grill',
        userId: 'dummy_user_id',
        items: [
          OrderItemEntity(
            menuItemId: 'item_003',
            name: 'Chicken Wings',
            quantity: 3,
            price: 120.0,
            imageUrl: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=300&h=200&fit=crop',
          ),
        ],
        totalAmount: 360.0,
        fulfillmentSlot: now.add(const Duration(hours: 3)),
        fulfillmentType: FulfillmentType.delivery,
        status: OrderStatus.delivered,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  /// Get dummy settings for UI testing
  SettingsEntity _getDummySettings() {
    final today = DateTime.now();
    return SettingsEntity(
      breakSlots: [
        DateTime(today.year, today.month, today.day, 10, 30), // 10:30 AM
        DateTime(today.year, today.month, today.day, 13, 0),  // 1:00 PM
        DateTime(today.year, today.month, today.day, 15, 30), // 3:30 PM
      ],
      orderCutoffMinutes: 5,
    );
  }
}
