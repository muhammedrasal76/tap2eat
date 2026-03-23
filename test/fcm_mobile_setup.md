# FCM Push Notifications — Mobile App Setup

## 1. Add dependency

```yaml
# pubspec.yaml
dependencies:
  firebase_messaging: ^14.x.x
```

## 2. Android — `android/app/src/main/AndroidManifest.xml`

Add inside `<application>`:
```xml
<meta-data
  android:name="com.google.firebase.messaging.default_notification_channel_id"
  android:value="default_channel" />
```

## 3. iOS — Xcode

- Enable **Push Notifications** capability in Xcode → Signing & Capabilities
- Upload APNs key in Firebase Console → Project Settings → Cloud Messaging → Apple app configuration

## 4. Initialize and save FCM token

Call this after the user logs in (once `uid` is available):

```dart
Future<void> initFcm(String uid) async {
  final messaging = FirebaseMessaging.instance;

  // Request permission (required on iOS)
  await messaging.requestPermission();

  // Save current token
  final token = await messaging.getToken();
  if (token != null) {
    await _saveToken(uid, token);
  }

  // Refresh token when it rotates
  messaging.onTokenRefresh.listen((newToken) => _saveToken(uid, newToken));
}

Future<void> _saveToken(String uid, String token) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'fcm_tokens': FieldValue.arrayUnion([token]),
  });
}
```

## 5. Handle incoming notifications

```dart
// Foreground
FirebaseMessaging.onMessage.listen((message) {
  // show in-app banner or snackbar
});

// Background tap → app opens
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  final type = message.data['type'];
  final orderId = message.data['order_id'];
  if (type == 'order_ready') {
    // navigate to order screen using orderId
  }
});
```

## 6. Remove token on logout

```dart
Future<void> onLogout(String uid) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fcm_tokens': FieldValue.arrayRemove([token]),
    });
  }
  await FirebaseMessaging.instance.deleteToken();
}
```

## Verify it's working

1. Log in on the device → check Firestore `users/{uid}.fcm_tokens` has a value
2. Mark an order as **ready** in the admin panel
3. Notification should appear on the device
