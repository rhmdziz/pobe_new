import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/bus/halte_service.dart';
import 'package:pobe_new/data/models/halte.dart';

class DestinationViewModel extends ChangeNotifier {
  DestinationViewModel(this._halteService);

  final HalteService _halteService;

  bool _haltesLoaded = false;
  List<Halte> _haltes = [];
  String startPointId = '';
  String endPointId = '';

  String startPoint = '';
  String endPoint = '';
  String fromTime = '';
  String toTime = '';

  Future<void> init(String start, String end) async {
    startPoint = start;
    endPoint = end;
    if (!_haltesLoaded) {
      await _loadHaltes();
    }
  }

  Future<void> _loadHaltes() async {
    _haltes = await _halteService.fetchHaltes();
    _haltesLoaded = true;
  }

  Future<List<Halte>> searchHaltes(String query) async {
    if (!_haltesLoaded) {
      await _loadHaltes();
    }
    final lower = query.toLowerCase();
    return _haltes
        .where((halte) => halte.name.toLowerCase().contains(lower))
        .toList();
  }

  void selectStart(Halte halte) {
    startPoint = halte.name;
    startPointId = halte.id;
    notifyListeners();
  }

  void selectEnd(Halte halte) {
    endPoint = halte.name;
    endPointId = halte.id;
    notifyListeners();
  }

  void setFromTime(String time) {
    fromTime = time;
    notifyListeners();
  }

  void setToTime(String time) {
    toTime = time;
    notifyListeners();
  }
}
