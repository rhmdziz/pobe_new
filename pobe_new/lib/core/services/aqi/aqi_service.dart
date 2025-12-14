import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/data/models/aqi_response.dart';

class AqiService {
  AqiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<AqiResponse> fetchAqi() async {
    final uri = Uri.parse('${ApiConstants.aqiBaseUrl}?token=${ApiConstants.aqiToken}');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load AQI data (${response.statusCode})');
    }

    final Map<String, dynamic> jsonResponse =
        json.decode(response.body) as Map<String, dynamic>;
    return AqiResponse.fromJson(jsonResponse);
  }
}
