class AqiResponse {
  AqiResponse({
    required this.status,
    required this.aqi,
    required this.time,
  });

  final String status;
  final int aqi;
  final String time;

  factory AqiResponse.fromJson(Map<String, dynamic> json) {
    return AqiResponse(
      status: json['status'] as String? ?? 'unknown',
      aqi: json['data']?['aqi'] as int? ?? 0,
      time: json['data']?['time']?['s'] as String? ?? '-',
    );
  }
}
