import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/news_comment.dart';

class NewsCommentService {
  NewsCommentService({http.Client? client, AuthStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client _client;
  final AuthStorage _storage;

  Future<List<NewsComment>> fetchComments(int newsId) async {
    final token = await _storage.readAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await _client.get(
      Uri.parse(ApiConstants.newsCommentsUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load comments (${response.statusCode})');
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => NewsComment.fromJson(item as Map<String, dynamic>))
        .where((c) => c.newsId == newsId)
        .toList();
  }

  Future<void> addComment({
    required int newsId,
    required String name,
    required String comment,
  }) async {
    final token = await _storage.readAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await _client.post(
      Uri.parse(ApiConstants.newsCommentsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
        'comment': comment,
        'newsId': newsId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add comment (${response.statusCode})');
    }
  }
}
