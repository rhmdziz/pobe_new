class Halte {
  const Halte({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Halte.fromJson(Map<String, dynamic> json) {
    return Halte(
      id: json['id'].toString(),
      name: json['nama_halte'] as String? ?? '-',
    );
  }
}
