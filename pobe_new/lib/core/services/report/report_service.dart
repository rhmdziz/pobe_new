import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';

class ReportService {
  ReportService({http.Client? client, AuthStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client _client;
  final AuthStorage _storage;

  Future<void> submitReport({
    required String title,
    required String content,
    required String authorEmail,
    File? imageFile,
  }) async {
    final token = await _storage.readAccessToken();
    if (token == null) throw Exception('Access token not found');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.reportsUrl),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['author'] = authorEmail;
    request.fields['content'] = content;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Failed to send report (${response.statusCode}): ${response.body}',
      );
    }
  }
}
