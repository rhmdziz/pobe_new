import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';

class AuthTokens {
  AuthTokens({required this.access, required this.refresh});

  final String access;
  final String refresh;

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  Uri _uri(String url) => Uri.parse(url);

  Future<AuthTokens> login(String username, String password) async {
    final response = await _client.post(
      _uri(ApiConstants.authTokenUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Login failed');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthTokens.fromJson(body);
  }

  Future<void> signup({
    required String username,
    required String password,
    String? email,
  }) async {
    final response = await _client.post(
      _uri(ApiConstants.signupUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Signup failed');
    }
  }
}
