import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/to_go_item.dart';
import 'package:pobe_new/data/models/to_go_review.dart';

class ToGoService {
  ToGoService({
    http.Client? client,
    AuthStorage? storage,
    String? baseUrl,
    Map<String, String>? endpoints,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage(),
        _baseUrl = baseUrl ?? ApiConstants.toGoBaseUrl,
        _endpoints = endpoints ?? ApiConstants.toGoEndpoints;

  final http.Client _client;
  final AuthStorage _storage;
  final String _baseUrl;
  final Map<String, String> _endpoints;

  Future<List<ToGoItem>> fetchByCategory(String category) async {
    final accessToken = await _storage.readAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final path = _endpoints[category];
    if (path == null || path.isEmpty) {
      throw Exception('Endpoint untuk $category belum dikonfigurasi');
    }

    final uri = _buildUri(path);
    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }

    final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((item) => ToGoItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ToGoReview>> fetchReviews(int itemId) async {
    final accessToken = await _storage.readAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final uri = Uri.parse('${ApiConstants.toGoBaseUrl}${ApiConstants.toGoReviewPath}');
    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load reviews (${response.statusCode})');
    }

    final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((item) => ToGoReview.fromJson(item as Map<String, dynamic>))
        .where((review) => review.itemId == itemId)
        .toList();
  }

  Future<void> submitReview({
    required int itemId,
    required int rating,
    required String name,
    required String review,
  }) async {
    final accessToken = await _storage.readAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final uri = Uri.parse('${ApiConstants.toGoBaseUrl}${ApiConstants.toGoReviewPath}');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'rating': rating.toString(),
        'name': name,
        'review': review,
        'foodId': itemId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit review (${response.statusCode})');
    }
  }

  Uri _buildUri(String path) {
    if (path.startsWith('http')) {
      return Uri.parse(path);
    }
    return Uri.parse('$_baseUrl$path');
  }
}
