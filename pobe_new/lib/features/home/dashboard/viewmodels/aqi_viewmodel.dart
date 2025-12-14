import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/aqi/aqi_service.dart';
import 'package:pobe_new/data/models/aqi_response.dart';

class AqiViewModel extends ChangeNotifier {
  AqiViewModel(this._service);

  final AqiService _service;

  bool isLoading = false;
  String? error;
  AqiResponse? data;
  bool _initialized = false;

  Future<void> load() async {
    if (_initialized) return;
    _initialized = true;
    await refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      data = await _service.fetchAqi();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
