import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/news.dart';

class NewsService {
  NewsService({http.Client? client, AuthStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client _client;
  final AuthStorage _storage;

  Future<List<News>> fetchNews() async {
    final accessToken = await _storage.readAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final response = await _client.get(
      Uri.parse(ApiConstants.newsBaseUrl),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load news (${response.statusCode})');
    }

    final List<dynamic> data =
        json.decode(response.body) as List<dynamic>;
    return data.map((item) => News.fromJson(item as Map<String, dynamic>)).toList();
  }
}
