import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/time_lock_helper.dart';
import '../../../home/domain/entities/break_slot_entity.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../../../home/domain/entities/settings_entity.dart';
import '../../../menu/presentation/providers/cart_provider.dart';
import '../../../delivery/domain/usecases/check_delivery_availability_usecase.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_active_order_count_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/watch_order_history_usecase.dart';
import '../../domain/usecases/watch_order_detail_usecase.dart';

/// Order state management provider
class OrderProvider with ChangeNotifier {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderHistoryUseCase getOrderHistoryUseCase;
  final GetOrderDetailUseCase getOrderDetailUseCase;
  final GetActiveOrderCountUseCase getActiveOrderCountUseCase;
  final CheckDeliveryAvailabilityUseCase checkDeliveryAvailabilityUseCase;
  final WatchOrderHistoryUseCase watchOrderHistoryUseCase;
  final WatchOrderDetailUseCase watchOrderDetailUseCase;
  final OrderRepository repository;

  OrderProvider({
    required this.createOrderUseCase,
    required this.getOrderHistoryUseCase,
    required this.getOrderDetailUseCase,
    required this.getActiveOrderCountUseCase,
    required this.checkDeliveryAvailabilityUseCase,
    required this.watchOrderHistoryUseCase,
    required this.watchOrderDetailUseCase,
    required this.repository,
  });

  // Checkout state
  FulfillmentType _fulfillmentType = FulfillmentType.pickup;
  BreakSlotEntity? _selectedBreakSlot;
  DateTime? _fulfillmentSlot;
  String _deliveryAddress = '';
  bool _isPlacingOrder = false;
  String? _lastCreatedOrderId;
  String? _checkoutError;

  // Order history state
  List<RecentOrderEntity> _orders = [];
  bool _isLoadingHistory = false;
  String? _historyError;

  // Order detail state
  RecentOrderEntity? _orderDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  // Delivery "now" availability state
  bool _isDeliveryNowAvailable = false;
  bool _isCheckingAvailability = false;
  bool _isNowSlotSelected = false;

  // Delivery person info state
  Map<String, String>? _deliveryPersonInfo;
  bool _deliveryPersonFetched = false;

  // Active order count state
  int _activeOrderCount = 0;
  bool _isLoadingActiveCount = false;
  String? _activeCountError;

  // Stream subscriptions
  StreamSubscription<List<RecentOrderEntity>>? _orderHistorySubscription;
  StreamSubscription<RecentOrderEntity?>? _orderDetailSubscription;
  String? _historyUserId;

  // Checkout getters
  FulfillmentType get fulfillmentType => _fulfillmentType;
  BreakSlotEntity? get selectedBreakSlot => _selectedBreakSlot;
  DateTime? get fulfillmentSlot => _fulfillmentSlot;
  String get deliveryAddress => _deliveryAddress;
  bool get isPlacingOrder => _isPlacingOrder;
  String? get lastCreatedOrderId => _lastCreatedOrderId;
  String? get checkoutError => _checkoutError;

  double get deliveryFee =>
      _fulfillmentType == FulfillmentType.delivery ? 10.0 : 0.0;

  // Delivery "now" getters
  bool get isDeliveryNowAvailable => _isDeliveryNowAvailable;
  bool get isCheckingAvailability => _isCheckingAvailability;
  bool get isNowSlotSelected => _isNowSlotSelected;

  // Order history getters
  List<RecentOrderEntity> get orders => _orders;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get historyError => _historyError;

  // Order detail getters
  RecentOrderEntity? get orderDetail => _orderDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  // Delivery person info getter
  Map<String, String>? get deliveryPersonInfo => _deliveryPersonInfo;

  // Active order count getters
  int get activeOrderCount => _activeOrderCount;
  bool get isLoadingActiveCount => _isLoadingActiveCount;
  String? get activeCountError => _activeCountError;
  int _maxOrders = 0;
  bool get isAtCapacity => _activeOrderCount >= _maxOrders && _maxOrders > 0;

  /// Set the fulfillment type (pickup or delivery)
  void setFulfillmentType(FulfillmentType type) {
    if (type == FulfillmentType.delivery && !_isDeliveryNowAvailable) return;
    _fulfillmentType = type;
    if (type == FulfillmentType.pickup) {
      _selectedBreakSlot = null;
      _fulfillmentSlot = null;
      _isNowSlotSelected = false;
    } else if (type == FulfillmentType.delivery) {
      checkDeliveryAvailability();
    }
    notifyListeners();
  }

  /// Select a break slot for delivery
  void selectBreakSlot(BreakSlotEntity slot) {
    _selectedBreakSlot = slot;
    _isNowSlotSelected = false;
    // Use the slot's start time as the fulfillment slot
    final now = DateTime.now();
    _fulfillmentSlot = DateTime(
      now.year,
      now.month,
      now.day,
      slot.startTime.hour,
      slot.startTime.minute,
    );
    notifyListeners();
  }

  /// Set the delivery address
  void setDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  /// Select the "Deliver Now" slot (~10 min from now)
  void selectNowSlot() {
    _isNowSlotSelected = true;
    _selectedBreakSlot = null;
    _fulfillmentSlot = DateTime.now().add(const Duration(minutes: 10));
    notifyListeners();
  }

  /// Check if any delivery student is currently available
  Future<void> checkDeliveryAvailability() async {
    _isCheckingAvailability = true;
    notifyListeners();

    try {
      _isDeliveryNowAvailable =
          await checkDeliveryAvailabilityUseCase(NoParams());
    } catch (_) {
      _isDeliveryNowAvailable = false;
    }

    _isCheckingAvailability = false;
    notifyListeners();
  }

  /// Get available break slots filtered by active, today's day, and past cutoff
  List<BreakSlotEntity> getAvailableBreakSlots(SettingsEntity? settings) {
    if (settings == null) return [];

    final now = DateTime.now();
    final currentDayOfWeek = now.weekday;

    return settings.breakSlots.where((slot) {
      if (!slot.isActive) return false;
      if (slot.dayOfWeek != currentDayOfWeek) return false;

      // Check if the slot hasn't passed cutoff
      final slotStart = DateTime(
        now.year,
        now.month,
        now.day,
        slot.startTime.hour,
        slot.startTime.minute,
      );

      return TimeLockHelper.canPlaceOrderForSlot(
        slotStart,
        now,
        cutoffMinutes: settings.orderCutoffMinutes,
      );
    }).toList();
  }

  /// Validate order before placing
  String? validateOrder(CartProvider cart, SettingsEntity? settings) {
    if (cart.isEmpty) return 'Cart is empty';

    if (_fulfillmentType == FulfillmentType.delivery) {
      if (_selectedBreakSlot == null && !_isNowSlotSelected) {
        return 'Please select a delivery time slot';
      }
      if (_fulfillmentSlot == null) {
        return 'Invalid delivery time slot';
      }
      if (_deliveryAddress.trim().isEmpty) {
        return 'Please enter your delivery address';
      }
    }

    return null;
  }

  /// Place an order
  Future<bool> placeOrder(CartProvider cart, String userId) async {
    _isPlacingOrder = true;
    _checkoutError = null;
    notifyListeners();

    try {
      final canteen = cart.currentCanteen;
      if (canteen == null) {
        _checkoutError = 'No canteen selected';
        _isPlacingOrder = false;
        notifyListeners();
        return false;
      }

      // For pickup, use a default fulfillment slot (now + 30 min)
      final slot = _fulfillmentSlot ??
          DateTime.now().add(const Duration(minutes: 30));

      final items = cart.cartItems
          .map((cartItem) => OrderItemEntity(
                menuItemId: cartItem.menuItem.id,
                name: cartItem.menuItem.name,
                quantity: cartItem.quantity,
                price: cartItem.menuItem.price,
              ))
          .toList();

      final orderId = await createOrderUseCase(CreateOrderParams(
        canteenId: canteen.id,
        canteenName: canteen.name,
        userId: userId,
        items: items,
        totalAmount: cart.subtotal + deliveryFee,
        fulfillmentSlot: slot,
        fulfillmentType: _fulfillmentType.value,
        deliveryFee: deliveryFee,
        deliveryAddress: _deliveryAddress.trim().isEmpty
            ? null
            : _deliveryAddress.trim(),
      ));

      _lastCreatedOrderId = orderId;
      _isPlacingOrder = false;

      // Clear cart after successful order
      cart.clearCart();

      // Reset checkout state
      _fulfillmentType = FulfillmentType.pickup;
      _selectedBreakSlot = null;
      _fulfillmentSlot = null;
      _deliveryAddress = '';
      _isNowSlotSelected = false;

      notifyListeners();
      return true;
    } catch (e) {
      _checkoutError = 'Failed to place order. Please try again.';
      _isPlacingOrder = false;
      notifyListeners();
      return false;
    }
  }

  /// Subscribe to real-time order history for a user.
  /// Idempotent — skips re-subscribing if already listening to the same userId.
  void fetchOrderHistory(String userId) {
    if (_historyUserId == userId && _orderHistorySubscription != null) return;
    _historyUserId = userId;
    _orderHistorySubscription?.cancel();
    _isLoadingHistory = true;
    _historyError = null;
    notifyListeners();

    _orderHistorySubscription = watchOrderHistoryUseCase(
      WatchOrderHistoryParams(userId: userId),
    ).listen(
      (orders) {
        _orders = orders;
        _isLoadingHistory = false;
        _historyError = null;
        notifyListeners();
      },
      onError: (e) {
        _orderHistorySubscription = null;
        _historyUserId = null;
        _isLoadingHistory = false;
        _historyError = 'Failed to load orders';
        notifyListeners();
      },
    );
  }

  /// Subscribe to real-time updates for a single order.
  void fetchOrderDetail(String orderId) {
    _orderDetailSubscription?.cancel();
    _isLoadingDetail = true;
    _detailError = null;
    _deliveryPersonInfo = null;
    _deliveryPersonFetched = false;
    notifyListeners();

    _orderDetailSubscription = watchOrderDetailUseCase(
      WatchOrderDetailParams(orderId: orderId),
    ).listen(
      (detail) {
        _orderDetail = detail;
        _isLoadingDetail = false;
        _detailError = null;

        // Fetch delivery person info once when student is assigned
        if (!_deliveryPersonFetched &&
            detail != null &&
            detail.deliveryStudentId != null &&
            detail.fulfillmentType == FulfillmentType.delivery) {
          _deliveryPersonFetched = true;
          repository
              .getDeliveryPersonInfo(detail.deliveryStudentId!)
              .then((info) {
            _deliveryPersonInfo = info;
            notifyListeners();
          });
        }

        notifyListeners();
      },
      onError: (e) {
        _isLoadingDetail = false;
        _detailError = 'Failed to load order details';
        notifyListeners();
      },
    );
  }

  /// Cancel the order detail subscription (call from page dispose).
  void cancelOrderDetailSubscription() {
    _orderDetailSubscription?.cancel();
    _orderDetailSubscription = null;
  }

  /// Fetch active order count for a canteen
  Future<void> fetchActiveOrderCount(String canteenId, {int maxOrders = 0}) async {
    _isLoadingActiveCount = true;
    _activeCountError = null;
    _maxOrders = maxOrders;
    notifyListeners();

    try {
      _activeOrderCount = await getActiveOrderCountUseCase(
        GetActiveOrderCountParams(canteenId: canteenId),
      );
      _isLoadingActiveCount = false;
      notifyListeners();
    } catch (e) {
      _isLoadingActiveCount = false;
      _activeCountError = 'Failed to load active order count';
      notifyListeners();
    }
  }

  /// Clear checkout error
  void clearCheckoutError() {
    _checkoutError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _orderHistorySubscription?.cancel();
    _orderDetailSubscription?.cancel();
    super.dispose();
  }
}
