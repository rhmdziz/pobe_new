class BusRoute {
  BusRoute({
    required this.id,
    required this.name,
    required this.stops,
  });

  final int id;
  final String name;
  final List<String> stops;

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'] as int,
      name: (json['nama_rute'] ?? '').toString(),
      stops: List<String>.from(json['rute'] as List<dynamic>),
    );
  }
}
