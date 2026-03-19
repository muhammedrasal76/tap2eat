import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
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

  void setPendingAssignment(Map<String, dynamic> data) {
    final expiresAtMs = int.tryParse(data['expiresAt']?.toString() ?? '');
    _pendingAssignment = DeliveryAssignmentEntity(
      assignmentId: data['assignmentId'] as String? ?? '',
      orderId: data['orderId'] as String? ?? '',
      canteenName: data['canteenName'] as String? ?? 'Unknown',
      totalAmount: double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0,
      deliveryFee: double.tryParse(data['deliveryFee']?.toString() ?? '0') ?? 0,
      itemCount: int.tryParse(data['itemCount']?.toString() ?? '0') ?? 0,
      expiresAt: expiresAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(expiresAtMs)
          : DateTime.now().add(const Duration(seconds: 60)),
    );
    notifyListeners();
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

      // If delivered, clear active order
      if (status == 'delivered') {
        _activeOrderId = null;
        _activeOrder = null;
        _orderSubscription?.cancel();
        _orderSubscription = null;
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

    _orderSubscription = repository.watchOrder(orderId).listen(
      (order) {
        _activeOrder = order;

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
