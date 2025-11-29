import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../config/constants/enum_values.dart';

/// Authentication state management provider
class AuthProvider with ChangeNotifier {
  firebase_auth.User? _firebaseUser;
  UserRole? _userRole;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  firebase_auth.User? get firebaseUser => _firebaseUser;
  UserRole? get userRole => _userRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Firebase sign in
      final credential = await firebase_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      // Fetch user role from Firestore
      await _fetchUserRole();

      _isLoading = false;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed. Please try again.';
      notifyListeners();
    }
  }

  /// Sign up with email, password, and role
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? classId, // For students
    String? designation, // For teachers
    required String phoneNumber,
    required String classroomNumber,
    required String blockName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 1. Create Firebase Auth user
      final userCredential = await firebase_auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Create Firestore user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'role': role.value,
        'phoneNumber': phoneNumber,
        'classroomNumber': classroomNumber,
        'blockName': blockName,
        if (role == UserRole.student && classId != null) 'classId': classId,
        if (role == UserRole.teacher && designation != null)
          'designation': designation,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Update local state
      _firebaseUser = userCredential.user;
      _userRole = role;

      _isLoading = false;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed. Please try again.';
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await firebase_auth.FirebaseAuth.instance.signOut();

      _firebaseUser = null;
      _userRole = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign out failed. Please try again.';
      notifyListeners();
    }
  }

  /// Initialize auth state on app startup
  /// Checks if user is already signed in and restores session
  Future<void> initAuthState() async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        _firebaseUser = currentUser;
        await _fetchUserRole();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to restore session';
      notifyListeners();
    }
  }

  /// Fetch user role from Firestore
  Future<void> _fetchUserRole() async {
    try {
      if (_firebaseUser == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser!.uid)
          .get();

      if (!doc.exists) {
        _errorMessage = 'User profile not found. Please contact support.';
        await signOut(); // Force sign out if profile missing
        throw Exception('User profile not found');
      }

      final roleString = doc.data()!['role'] as String;
      _userRole = UserRoleExtension.fromString(roleString);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user profile';
      _userRole = null;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get user-friendly error message from Firebase auth error code
  String _getAuthErrorMessage(String code) {
    switch (code) {
      // Registration errors
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';

      // Login errors
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many login attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
