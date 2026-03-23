import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/time_lock_helper.dart';
import '../../domain/entities/break_slot_entity.dart';
import '../../domain/entities/canteen_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/entities/recent_order_entity.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/get_canteens_usecase.dart';
import '../../domain/usecases/get_recent_orders_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/search_canteens_usecase.dart';
import '../../domain/usecases/watch_recent_orders_usecase.dart';

/// Home screen state management provider
class HomeProvider with ChangeNotifier {
  final GetCanteensUseCase getCanteensUseCase;
  final GetRecentOrdersUseCase getRecentOrdersUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final SearchCanteensUseCase searchCanteensUseCase;
  final WatchRecentOrdersUseCase watchRecentOrdersUseCase;

  // Dummy data flag - set to false when Firebase is ready
  static const bool _useDummyData = false;

  HomeProvider({
    required this.getCanteensUseCase,
    required this.getRecentOrdersUseCase,
    required this.getSettingsUseCase,
    required this.searchCanteensUseCase,
    required this.watchRecentOrdersUseCase,
  });

  // State
  List<CanteenEntity> _canteens = [];
  List<RecentOrderEntity> _recentOrders = [];
  SettingsEntity? _settings;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;

  // Stream subscriptions
  StreamSubscription<List<RecentOrderEntity>>? _recentOrdersSubscription;

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
        // Fetch canteens and settings in parallel; recent orders via real-time stream
        await Future.wait([
          _fetchCanteens(),
          _fetchSettings(),
        ]);
        _subscribeToRecentOrders(userId);
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

  /// Subscribe to real-time recent orders stream.
  void _subscribeToRecentOrders(String userId) {
    _recentOrdersSubscription?.cancel();
    _recentOrdersSubscription = watchRecentOrdersUseCase(
      WatchRecentOrdersParams(userId: userId),
    ).listen(
      (orders) {
        _recentOrders = orders;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Failed to watch recent orders: $e');
      },
    );
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

  @override
  void dispose() {
    _recentOrdersSubscription?.cancel();
    super.dispose();
  }

  // ==================== Dummy Data Methods ====================

  /// Get dummy canteens for UI testing
  List<CanteenEntity> _getDummyCanteens() {
    return [
      CanteenEntity(
        id: 'canteen_001',
        name: 'The Grill',
        isActive: true,
        maxConcurrentOrders: 50,
        menuItems: [
          MenuItemEntity(
            id: 'item_001',
            name: 'Burger Combo',
            description: 'Beef burger with fries and drink',
            price: 150.0,
            category: 'Burgers',
            isAvailable: true,
            stock: 50,
          ),
          MenuItemEntity(
            id: 'item_002',
            name: 'Grilled Chicken',
            description: 'Grilled chicken with vegetables',
            price: 180.0,
            category: 'Grilled',
            isAvailable: true,
            stock: 50,
          ),
          MenuItemEntity(
            id: 'item_003',
            name: 'Chicken Wings',
            description: 'Crispy chicken wings with sauce',
            price: 120.0,
            category: 'Appetizers',
            isAvailable: true,
            stock: 50,
          ),
        ],
      ),
      CanteenEntity(
        id: 'canteen_002',
        name: 'Pasta Paradise',
        isActive: true,
        maxConcurrentOrders: 40,
        menuItems: [
          MenuItemEntity(
            id: 'item_004',
            name: 'Spaghetti Carbonara',
            description: 'Creamy pasta with bacon',
            price: 200.0,
            category: 'Pasta',
            isAvailable: true,
            stock: 50,
          ),
          MenuItemEntity(
            id: 'item_005',
            name: 'Margherita Pizza',
            description: 'Classic tomato and mozzarella pizza',
            price: 250.0,
            category: 'Pizza',
            isAvailable: true,
            stock: 50,
          ),
          MenuItemEntity(
            id: 'item_006',
            name: 'Caesar Salad',
            description: 'Fresh salad with Caesar dressing',
            price: 100.0,
            category: 'Salads',
            isAvailable: true,
            stock: 50,
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
          ),
        ],
        totalAmount: 300.0,
        fulfillmentSlot: now.add(const Duration(hours: 2)),
        fulfillmentType: FulfillmentType.pickup,
        status: OrderStatus.completed,
        deliveryFee: 0,
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
          ),
        ],
        totalAmount: 200.0,
        fulfillmentSlot: now.add(const Duration(hours: 1)),
        fulfillmentType: FulfillmentType.pickup,
        status: OrderStatus.completed,
        deliveryFee: 0,
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
          ),
        ],
        totalAmount: 360.0,
        fulfillmentSlot: now.add(const Duration(hours: 3)),
        fulfillmentType: FulfillmentType.delivery,
        status: OrderStatus.delivered,
        deliveryFee: 10,
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
        BreakSlotEntity(
          startTime: DateTime(today.year, today.month, today.day, 10, 30),
          endTime: DateTime(today.year, today.month, today.day, 11, 0),
          dayOfWeek: today.weekday,
          label: 'Morning Break',
          isActive: true,
        ),
        BreakSlotEntity(
          startTime: DateTime(today.year, today.month, today.day, 13, 0),
          endTime: DateTime(today.year, today.month, today.day, 13, 30),
          dayOfWeek: today.weekday,
          label: 'Lunch Break',
          isActive: true,
        ),
        BreakSlotEntity(
          startTime: DateTime(today.year, today.month, today.day, 15, 30),
          endTime: DateTime(today.year, today.month, today.day, 16, 0),
          dayOfWeek: today.weekday,
          label: 'Afternoon Break',
          isActive: true,
        ),
      ],
      orderCutoffMinutes: 5,
    );
  }
}
