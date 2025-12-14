import 'package:flutter/foundation.dart';
import 'package:pobe_new/core/services/bus/bus_schedule_service.dart';
import 'package:pobe_new/core/services/bus/halte_service.dart';
import 'package:pobe_new/data/models/bus_route.dart';
import 'package:pobe_new/data/models/bus_schedule.dart';

enum LoadState { idle, loading, success, error }

class DestinationResultViewModel extends ChangeNotifier {
  DestinationResultViewModel(
    this._busService,
    this._halteService,
  );

  final BusScheduleService _busService;
  final HalteService _halteService;

  LoadState state = LoadState.idle;
  String? error;

  List<BusSchedule> schedules = [];
  Map<String, String> halteNames = {};
  Map<int, List<String>> routeStops = {};
  Map<int, String> routeNames = {};

  // =========================
  // PUBLIC API
  // =========================
  Future<void> load({
    required String startPointId,
    required String endPoint,
    required String fromTime,
    required String toTime,
  }) async {
    state = LoadState.loading;
    error = null;
    notifyListeners();

    try {
      final allSchedules = await _busService.fetchSchedules();
      await _loadHaltes();

      schedules = _filterSchedules(
        allSchedules,
        startPointId,
        fromTime,
        toTime,
      );

      await _prefetchRouteStops();

      state = LoadState.success;
    } catch (e) {
      error = e.toString();
      state = LoadState.error;
    }

    notifyListeners();
  }

  // =========================
  // INTERNAL
  // =========================
  List<BusSchedule> _filterSchedules(
    List<BusSchedule> schedules,
    String startPointId,
    String fromTime,
    String toTime,
  ) {
    return schedules.where((schedule) {
      final isStartMatch = schedule.halteId.toString() == startPointId;
      if (!isStartMatch) return false;

      return schedule.timesWithinRange(fromTime, toTime).isNotEmpty;
    }).toList();
  }

  Future<void> _loadHaltes() async {
    final haltes = await _halteService.fetchHaltes();
    halteNames = {for (final h in haltes) h.id: h.name};
  }

  Future<void> _prefetchRouteStops() async {
    final routeIds = schedules.map((e) => e.routeId).toSet();

    for (final id in routeIds) {
      if (!routeStops.containsKey(id)) {
        final BusRoute route = await _busService.fetchRoute(id);
        routeStops[id] = route.stops;
        routeNames[id] = route.name;
      }
    }
  }
}
