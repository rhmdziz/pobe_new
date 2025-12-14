class ToGoReview {
  const ToGoReview({
    required this.id,
    required this.rating,
    required this.name,
    required this.review,
    required this.itemId,
  });

  final int id;
  final int rating;
  final String name;
  final String review;
  final int itemId;

  factory ToGoReview.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic value) {
      try {
        return int.parse(value.toString());
      } catch (_) {
        return 0;
      }
    }

    return ToGoReview(
      id: _parseInt(json['id']),
      rating: _parseInt(json['rating']),
      name: json['name'] as String? ?? '-',
      review: json['review'] as String? ?? '',
      itemId: _parseInt(json['foodId'] ?? json['itemId']),
    );
  }
}
