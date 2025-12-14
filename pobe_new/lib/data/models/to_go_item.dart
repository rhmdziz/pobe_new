class ToGoItem {
  const ToGoItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.priceLevel,
    required this.id,
    this.location,
    this.operationalDay,
    this.operationalHour,
    this.phone,
    this.minPrice,
    this.maxPrice,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final int rating;
  final int reviewCount;
  final int priceLevel;
  final String? location;
  final String? operationalDay;
  final String? operationalHour;
  final String? phone;
  final String? minPrice;
  final String? maxPrice;
  final double? latitude;
  final double? longitude;

  factory ToGoItem.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic value) {
      try {
        return int.parse(value.toString());
      } catch (_) {
        return 0;
      }
    }

    double? _parseDouble(dynamic value) {
      try {
        return double.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return ToGoItem(
      id: _parseInt(json['id']),
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'No Name',
      description: json['desc'] as String? ?? 'No Description',
      imageUrl: json['image'] as String? ?? '',
      rating: _parseInt(json['rating']),
      reviewCount: _parseInt(json['review']),
      priceLevel: _parseInt(json['price']),
      location: json['location'] as String?,
      operationalDay: json['operational_day'] as String?,
      operationalHour: json['operational_hour'] as String?,
      phone: json['phone'] as String?,
      minPrice: json['min_price']?.toString(),
      maxPrice: json['max_price']?.toString(),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
    );
  }
}
