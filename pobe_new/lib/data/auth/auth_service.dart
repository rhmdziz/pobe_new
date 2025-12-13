import 'dart:convert';

import 'package:http/http.dart' as http;

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

  Future<AuthTokens> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('https://rhmdziz.pythonanywhere.com/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthTokens.fromJson(body);
  }
}
