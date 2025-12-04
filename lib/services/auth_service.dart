import 'package:flutter/material.dart';

// Mock User model matching your TypeScript type
class User {
  final String name;
  final String email;
  final String provider; // 'google' or 'email'

  User({required this.name, required this.email, required this.provider});
}

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Simulate Sign In
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _currentUser = User(name: "Guest User", email: email, provider: "email");
    _isLoading = false;
    notifyListeners();
  }

  // Simulate Google Sign In
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = User(name: "Alex", email: "alex@gmail.com", provider: "google");
    _isLoading = false;
    notifyListeners();
  }

  // Simulate Sign Up
  Future<void> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = User(name: name, email: email, provider: "email");
    _isLoading = false;
    notifyListeners();
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}