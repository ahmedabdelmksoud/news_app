import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/services/firebase_services.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseServices _firebaseServices = FirebaseServices();
  bool _isLoggedIn = false;
  String _username = '';
  String _email = '';
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() {
    final currentUser = _firebaseServices.getCurrentUser();
    if (currentUser != null) {
      _email = currentUser.email ?? '';
      _username = currentUser.displayName ?? _email.split('@')[0];
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;

      // Validation
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required';
        return false;
      }
      if (!email.contains('@')) {
        _errorMessage = 'Invalid email format';
        return false;
      }
      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        return false;
      }

      final userCredential = await _firebaseServices.login(email, password);

      _email = userCredential.user?.email ?? email;
      _username = userCredential.user?.displayName ?? email.split('@')[0];
      _isLoggedIn = true;

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed';
      _isLoggedIn = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      _errorMessage = null;

      // Validation
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'All fields are required';
        return false;
      }
      if (!email.contains('@')) {
        _errorMessage = 'Invalid email format';
        return false;
      }
      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        return false;
      }

      final userCredential = await _firebaseServices.signUp(email, password);

      _username = username;
      _email = userCredential.user?.email ?? email;
      _isLoggedIn = true;

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Signup failed';
      _isLoggedIn = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseServices.logout();
      _isLoggedIn = false;
      _username = '';
      _email = '';
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      notifyListeners();
    }
  }
}
