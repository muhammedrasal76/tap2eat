import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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

      // TODO: Implement Firebase sign in
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // _firebaseUser = credential.user;
      //
      // // TODO: Fetch user role from Firestore
      // await _fetchUserRole();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
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
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Implement Firebase sign up
      // TODO: Create user document in Firestore with role-specific fields

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement Firebase sign out
      // await FirebaseAuth.instance.signOut();

      _firebaseUser = null;
      _userRole = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Fetch user role from Firestore
  Future<void> _fetchUserRole() async {
    // TODO: Implement fetching user role from Firestore
    // Example:
    // final doc = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_firebaseUser!.uid)
    //     .get();
    // _userRole = UserRoleExtension.fromString(doc.data()!['role']);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
