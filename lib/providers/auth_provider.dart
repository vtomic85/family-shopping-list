import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  
  User? _user;
  bool _isLoading = true;
  String? _error;
  StreamSubscription<User?>? _authSubscription;

  AuthProvider({required AuthService authService}) : _authService = authService {
    _init();
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;
  String? get userEmail => _user?.email;
  String? get userId => _user?.uid;
  String? get displayName => _user?.displayName;
  String? get photoUrl => _user?.photoURL;

  void _init() {
    _authSubscription = _authService.authStateChanges.listen(
      (user) {
        _user = user;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.signInWithGoogle();
      
      if (result == null) {
        // User cancelled
        _isLoading = false;
        notifyListeners();
        return false;
      }

      return true;
    } catch (e) {
      _error = _getReadableError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signOut();
    } catch (e) {
      _error = _getReadableError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear any error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _getReadableError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'An account already exists with this email using a different sign-in method.';
        case 'invalid-credential':
          return 'The credential is invalid or has expired.';
        case 'operation-not-allowed':
          return 'Google sign-in is not enabled. Please contact support.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return error.message ?? 'An authentication error occurred.';
      }
    }
    return error.toString();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
