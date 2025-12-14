import 'package:intl/intl.dart';

DateTime _parseTime(String timeString) {
  return DateFormat('HH:mm').parseStrict(timeString);
}

DateTime _parseTimeWithSeconds(String timeString) {
  return DateFormat('HH:mm:ss').parseStrict(timeString);
}

class BusSchedule {
  BusSchedule({
    required this.routeId,
    required this.halteId,
    required this.busNumber,
    required this.url,
    required this.times,
  });

  final int routeId;
  final int halteId;
  final int busNumber;
  final String url;
  final List<String> times;

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      url: json['url'] as String? ?? '',
      routeId: json['rute'] as int? ?? 0,
      halteId: json['halte'] as int? ?? 0,
      busNumber: json['nomor_bis'] as int? ?? 0,
      times: [
        json['waktu_1'] as String? ?? '',
        json['waktu_2'] as String? ?? '',
        json['waktu_3'] as String? ?? '',
        json['waktu_4'] as String? ?? '',
        json['waktu_5'] as String? ?? '',
        json['waktu_6'] as String? ?? '',
        json['waktu_7'] as String? ?? '',
      ].where((t) => t.isNotEmpty).toList(),
    );
  }

  List<Map<String, String>> timesWithinRange(String fromTime, String toTime) {
    final from = _parseTime(fromTime);
    final to = _parseTime(toTime);

    final List<Map<String, String>> result = [];
    for (var i = 0; i < times.length; i++) {
      final t = times[i];
      if (t.isEmpty) continue;
      final parsed = _parseTimeWithSeconds(t);
      if (parsed.isAfter(from) && parsed.isBefore(to)) {
        result.add({'waktu': t, 'index': 'waktu_${i + 1}'});
      }
    }
    return result;
  }
}
