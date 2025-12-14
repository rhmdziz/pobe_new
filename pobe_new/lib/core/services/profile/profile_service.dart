import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/user_profile.dart';

class ProfileService {
  ProfileService({http.Client? client, AuthStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client _client;
  final AuthStorage _storage;

  Future<UserProfile> fetchProfile({String? overrideUrl}) async {
    final accessToken = await _storage.readAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final uri = Uri.parse(
      overrideUrl?.isNotEmpty == true ? overrideUrl! : ApiConstants.userProfileUrl,
    );
    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load profile (${response.statusCode})');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    return UserProfile.fromJson(body);
  }
}
