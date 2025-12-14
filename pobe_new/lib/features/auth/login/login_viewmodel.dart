import 'package:flutter/material.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/core/services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._authService, this._storage);

  final AuthService _authService;
  final AuthStorage _storage;

  bool isLoading = false;
  String? error;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final tokens = await _authService.login(username, password);
      await _storage.saveTokens(tokens.access, tokens.refresh);
      // Simpan identitas dasar agar bisa dipakai fitur lain (mis. report)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', username);
      await prefs.setString('username', username);
      return true;
    } catch (e) {
      error = 'Login failed';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
