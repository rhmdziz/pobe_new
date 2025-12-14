import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pobe_new/constants/api_constants.dart';
import 'package:pobe_new/core/storage/auth_storage.dart';
import 'package:pobe_new/data/models/bus_route.dart';
import 'package:pobe_new/data/models/bus_schedule.dart';

class BusScheduleService {
  BusScheduleService({http.Client? client, AuthStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? AuthStorage();

  final http.Client _client;
  final AuthStorage _storage;

  Future<List<BusSchedule>> fetchSchedules() async {
    final token = await _storage.readAccessToken();
    if (token == null) throw Exception('Access token not found');

    final response = await _client.get(
      Uri.parse(ApiConstants.busSchedulesUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load bus schedules (${response.statusCode})');
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data.map((e) => BusSchedule.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<BusRoute> fetchRoute(int routeId) async {
    final token = await _storage.readAccessToken();
    if (token == null) throw Exception('Access token not found');

    final response = await _client.get(
      Uri.parse('${ApiConstants.busRoutesUrl}$routeId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load bus route ($routeId)');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return BusRoute.fromJson(data);
  }
}
