import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/category/to_go_service.dart';
import 'package:pobe_new/data/models/to_go_item.dart';

class ToGoViewModel extends ChangeNotifier {
  ToGoViewModel(this._service, {required this.category});

  final ToGoService _service;
  final String category;
  ToGoService get service => _service;

  bool isLoading = false;
  String? error;
  List<ToGoItem> items = [];

  Future<void> load() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      items = await _service.fetchByCategory(category);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
