import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tap2eat_app/firebase_options.dart';

/// Singleton provider for Firebase instances
class FirebaseProvider {
  FirebaseProvider._();

  static final FirebaseProvider _instance = FirebaseProvider._();
  static FirebaseProvider get instance => _instance;

  // Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  /// Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  }

  /// Configure Firestore settings
  void configureFirestore() {
    // Enable offline persistence
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
