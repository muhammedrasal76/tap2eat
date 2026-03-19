import 'dart:async';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  void Function(Map<String, dynamic> data)? _deliveryAssignmentHandler;
  void Function(String route, {String? orderId})? _navigationHandler;

  bool _initialized = false;

  void setDeliveryAssignmentHandler(
      void Function(Map<String, dynamic> data)? handler) {
    _deliveryAssignmentHandler = handler;
  }

  void setNavigationHandler(
      void Function(String route, {String? orderId})? handler) {
    _navigationHandler = handler;
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'delivery_assignments',
      'Delivery Assignments',
      description: 'Notifications for delivery assignment requests',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // FCM foreground message listener
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // FCM message opened app listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check for initial message (app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    // Token refresh listener
    _messaging.onTokenRefresh.listen(_registerToken);
  }

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Get FCM token with proper iOS handling:
  /// 1. Request notification permission (required on iOS before getting token)
  /// 2. Wait for APNs token (iOS only — FCM depends on APNs)
  /// 3. Get FCM token
  Future<String?> getFcmToken() async {
    // Step 1: Request permission (no-op if already granted/denied)
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      debugPrint('FCM: Notification permission denied');
      return null;
    }

    // Step 2: On iOS, wait for APNs token before requesting FCM token
    if (Platform.isIOS) {
      String? apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        // APNs token can take a moment after permission is granted
        for (int i = 0; i < 10; i++) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken != null) break;
        }
      }
      if (apnsToken == null) {
        debugPrint('FCM: APNs token not available');
        return null;
      }
    }

    // Step 3: Get FCM token
    return _messaging.getToken();
  }

  Future<void> registerCurrentToken(String userId) async {
    final token = await getFcmToken();
    if (token != null) {
      await _registerTokenWithUserId(token, userId);
    }
  }

  Future<void> _registerToken(String token) async {
    // Token refresh — re-register if we have a stored userId
    // This is called automatically; the provider should call registerCurrentToken
    debugPrint('FCM token refreshed: $token');
  }

  Future<void> _registerTokenWithUserId(String token, String userId) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('registerFcmToken')
          .call({'token': token, 'userId': userId});
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final type = message.data['type'] as String?;

    if (type == 'delivery_assignment') {
      // Route to assignment popup handler
      _deliveryAssignmentHandler?.call(message.data);
    } else {
      // Show local notification for other types
      _showLocalNotification(message);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final type = message.data['type'] as String?;
    final orderId = message.data['orderId'] as String?;

    if (type == 'delivery_assignment' && orderId != null) {
      _navigationHandler?.call('/delivery/$orderId', orderId: orderId);
    } else if (orderId != null) {
      _navigationHandler?.call('/order/$orderId', orderId: orderId);
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.startsWith('order:')) {
      final orderId = payload.substring(6);
      _navigationHandler?.call('/order/$orderId', orderId: orderId);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final type = message.data['type'] as String?;
    final title = message.notification?.title ?? _getTitleForType(type);
    final body = message.notification?.body ?? _getBodyForType(type);
    final orderId = message.data['orderId'] as String?;

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'delivery_assignments',
          'Delivery Assignments',
          channelDescription: 'Notifications for delivery assignment requests',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: orderId != null ? 'order:$orderId' : null,
    );
  }

  String _getTitleForType(String? type) {
    switch (type) {
      case 'delivery_assigned':
        return 'Delivery Student Assigned';
      case 'order_delivering':
        return 'Order Being Delivered';
      case 'order_delivered':
        return 'Order Delivered';
      case 'order_converted_to_pickup':
        return 'Order Converted to Pickup';
      default:
        return 'Tap2Eat';
    }
  }

  String _getBodyForType(String? type) {
    switch (type) {
      case 'delivery_assigned':
        return 'A delivery student has been assigned to your order';
      case 'order_delivering':
        return 'Your order is being delivered';
      case 'order_delivered':
        return 'Your order has been delivered!';
      case 'order_converted_to_pickup':
        return 'Your delivery order has been converted to pickup';
      default:
        return 'You have a new notification';
    }
  }
}
