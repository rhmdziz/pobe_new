import 'package:flutter/material.dart';
import 'package:pobe_new/core/services/auth/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel(this._authService);

  final AuthService _authService;

  bool isLoading = false;
  String? error;

  Future<bool> signup({
    required String username,
    required String password,
    String? email,
  }) async {
    isLoadinsg = true;
    error = null;
    notifyListeners();

    try {
      await _authService.signup(
        username: username,
        password: password,
        email: email,
      );

      // Setelah daftar, login untuk mengambil token.
      // final tokens = await _authService.login(username, password);
      // await _storage.saveTokens(tokens.access, tokens.refresh);
      return true;
    } catch (_) {
      error = 'Signup failed';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
