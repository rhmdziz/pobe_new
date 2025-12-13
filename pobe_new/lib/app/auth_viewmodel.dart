import 'package:flutter/material.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/auth/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(
    this._authService,
    this._storage,
  );

  final AuthService _authService;
  final AuthStorage _storage;

  AuthStatus status = AuthStatus.unknown;
  bool isLoading = false;
  String? error;

  Future<void> checkSession() async {
    final token = await _storage.readAccessToken();
    status = token == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final tokens = await _authService.login(username, password);
      await _storage.saveTokens(tokens.access, tokens.refresh);

      status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      error = 'Login failed';
      status = AuthStatus.unauthenticated;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
