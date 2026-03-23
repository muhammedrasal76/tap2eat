import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../../domain/entities/customer_info_entity.dart';
import '../../domain/entities/delivery_assignment_entity.dart';
import '../../domain/usecases/accept_assignment_usecase.dart';
import '../../domain/usecases/get_delivery_history_usecase.dart';
import '../../domain/usecases/reject_assignment_usecase.dart';
import '../../domain/usecases/update_delivery_status_usecase.dart';
import '../../domain/usecases/update_online_status_usecase.dart';
import '../../domain/repositories/delivery_repository.dart';

class DeliveryProvider with ChangeNotifier {
  final UpdateOnlineStatusUseCase updateOnlineStatusUseCase;
  final AcceptAssignmentUseCase acceptAssignmentUseCase;
  final RejectAssignmentUseCase rejectAssignmentUseCase;
  final UpdateDeliveryStatusUseCase updateDeliveryStatusUseCase;
  final GetDeliveryHistoryUseCase getDeliveryHistoryUseCase;
  final DeliveryRepository repository;

  DeliveryProvider({
    required this.updateOnlineStatusUseCase,
    required this.acceptAssignmentUseCase,
    required this.rejectAssignmentUseCase,
    required this.updateDeliveryStatusUseCase,
    required this.getDeliveryHistoryUseCase,
    required this.repository,
  });

  // Online/offline state
  bool _isOnline = false;
  bool _isTogglingStatus = false;

  // Active delivery state
  String? _activeOrderId;
  RecentOrderEntity? _activeOrder;
  StreamSubscription? _orderSubscription;

  // Customer info for current active delivery
  CustomerInfoEntity? _customerInfo;
  bool _customerInfoFetched = false;

  // Pending assignment state
  DeliveryAssignmentEntity? _pendingAssignment;

  // Delivery history state
  List<RecentOrderEntity> _deliveryHistory = [];
  bool _isLoadingHistory = false;
  String? _historyError;

  // Loading states for popup
  bool _isAccepting = false;
  bool _isRejecting = false;

  // Error
  String? _error;

  // Getters
  bool get isOnline => _isOnline;
  bool get isTogglingStatus => _isTogglingStatus;
  String? get activeOrderId => _activeOrderId;
  RecentOrderEntity? get activeOrder => _activeOrder;
  DeliveryAssignmentEntity? get pendingAssignment => _pendingAssignment;
  List<RecentOrderEntity> get deliveryHistory => _deliveryHistory;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get historyError => _historyError;
  bool get isAccepting => _isAccepting;
  bool get isRejecting => _isRejecting;
  String? get error => _error;
  bool get hasActiveDelivery => _activeOrderId != null;
  CustomerInfoEntity? get customerInfo => _customerInfo;

  Future<void> toggleOnlineStatus(String userId) async {
    _isTogglingStatus = true;
    _error = null;
    notifyListeners();

    try {
      final newStatus = !_isOnline;
      await updateOnlineStatusUseCase(UpdateOnlineStatusParams(
        userId: userId,
        isOnline: newStatus,
      ));
      _isOnline = newStatus;
      _isTogglingStatus = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update status';
      _isTogglingStatus = false;
      notifyListeners();
    }
  }

  Future<void> setPendingAssignment(Map<String, dynamic> data) async {
    // Accept both camelCase (new CF) and snake_case (old CF) for compatibility
    final orderId = data['orderId'] as String? ?? data['order_id'] as String? ?? '';
    final assignmentId = data['assignmentId'] as String? ?? data['assignment_id'] as String? ?? '';
    final expiresAtMs = int.tryParse(data['expiresAt']?.toString() ?? '');
    final expiresAt = expiresAtMs != null
        ? DateTime.fromMillisecondsSinceEpoch(expiresAtMs)
        : DateTime.now().add(const Duration(seconds: 60));

    // Show popup immediately with whatever the FCM payload has
    _pendingAssignment = DeliveryAssignmentEntity(
      assignmentId: assignmentId,
      orderId: orderId,
      canteenName: data['canteenName'] as String? ?? 'Loading...',
      totalAmount: double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0,
      deliveryFee: double.tryParse(data['deliveryFee']?.toString() ?? '0') ?? 0,
      itemCount: int.tryParse(data['itemCount']?.toString() ?? '0') ?? 0,
      expiresAt: expiresAt,
    );
    notifyListeners();

    // Fetch accurate data from Firestore (handles old orders without canteen_name)
    if (orderId.isNotEmpty) {
      try {
        final order = await repository.watchOrder(orderId).first;
        if (_pendingAssignment == null) return; // cleared while fetching (reject/timeout)
        _pendingAssignment = DeliveryAssignmentEntity(
          assignmentId: assignmentId,
          orderId: orderId,
          canteenName: order.canteenName.isNotEmpty ? order.canteenName : (_pendingAssignment!.canteenName),
          totalAmount: order.totalAmount,
          deliveryFee: order.deliveryFee,
          itemCount: order.items.length,
          expiresAt: expiresAt,
        );
        notifyListeners();
      } catch (_) {
        // Keep FCM data if fetch fails — popup is already visible
      }
    }
  }

  void clearPendingAssignment() {
    _pendingAssignment = null;
    notifyListeners();
  }

  Future<bool> acceptAssignment(String userId) async {
    if (_pendingAssignment == null) return false;

    _isAccepting = true;
    _error = null;
    notifyListeners();

    try {
      final orderId = await acceptAssignmentUseCase(AcceptAssignmentParams(
        assignmentId: _pendingAssignment!.assignmentId,
        orderId: _pendingAssignment!.orderId,
        userId: userId,
      ));

      _activeOrderId = orderId;
      _pendingAssignment = null;
      _isAccepting = false;
      notifyListeners();

      watchActiveOrder(orderId);
      return true;
    } catch (e) {
      _error = 'Failed to accept assignment';
      _isAccepting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectAssignment(String userId) async {
    if (_pendingAssignment == null) return false;

    _isRejecting = true;
    _error = null;
    notifyListeners();

    try {
      await rejectAssignmentUseCase(RejectAssignmentParams(
        assignmentId: _pendingAssignment!.assignmentId,
        userId: userId,
      ));

      _pendingAssignment = null;
      _isRejecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to reject assignment';
      _isRejecting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDeliveryStatus(String orderId, String status) async {
    _error = null;
    notifyListeners();

    try {
      await updateDeliveryStatusUseCase(UpdateDeliveryStatusParams(
        orderId: orderId,
        status: status,
      ));

      // If delivered, mark as no longer active.
      // Do NOT clear _activeOrder or cancel the subscription here —
      // the watchActiveOrder stream handler will receive the 'delivered'
      // Firestore event and clean up, keeping _activeOrder intact so the
      // tracking page doesn't flash a spinner before the completion popup shows.
      if (status == 'delivered') {
        _activeOrderId = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update delivery status';
      notifyListeners();
      return false;
    }
  }

  void watchActiveOrder(String orderId) {
    _orderSubscription?.cancel();
    _activeOrderId = orderId;
    _customerInfo = null;
    _customerInfoFetched = false;

    _orderSubscription = repository.watchOrder(orderId).listen(
      (order) {
        _activeOrder = order;

        // Fetch customer info once when we first get the order
        if (!_customerInfoFetched && order.userId.isNotEmpty) {
          _customerInfoFetched = true;
          repository.getCustomerInfo(order.userId).then((info) {
            _customerInfo = info;
            notifyListeners();
          });
        }

        // If order was cancelled or delivered, stop watching but keep the
        // order data so the UI can display the final state.
        if (order.status.value == 'cancelled' ||
            order.status.value == 'delivered') {
          _activeOrderId = null;
          _orderSubscription?.cancel();
          _orderSubscription = null;
        }

        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error watching order: $e');
        _error = 'Failed to load order details';
        notifyListeners();
      },
    );
  }

  Future<void> fetchDeliveryHistory(String userId) async {
    _isLoadingHistory = true;
    _historyError = null;
    notifyListeners();

    try {
      _deliveryHistory = await getDeliveryHistoryUseCase(
        GetDeliveryHistoryParams(userId: userId),
      );
      _isLoadingHistory = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistory = false;
      _historyError = 'Failed to load delivery history';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }
}
