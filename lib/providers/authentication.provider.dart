import 'package:flutter/material.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/services/authentication.service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationService _authService;
  User? _currentUser;

  AuthenticationProvider(this._authService);

  User? get currentUser => _currentUser;

  Future<void> signIn(String email, String password) async {
    _currentUser = await _authService.signInWithEmail(email, password);
    notifyListeners();
  }

  Future<void> register(String email, String password, String username) async {
    _currentUser = await _authService.registerWithEmail(email, password, username);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // void updateCurrentUser(User user) {
  //   await _authService.upd();
  //   _currentUser = user;
  //   notifyListeners();
  // }
}
