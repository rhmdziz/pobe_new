class NewsComment {
  const NewsComment({
    required this.id,
    required this.name,
    required this.datetime,
    required this.comment,
    required this.newsId,
  });

  final int id;
  final String name;
  final DateTime datetime;
  final String comment;
  final int newsId;

  factory NewsComment.fromJson(Map<String, dynamic> json) {
    return NewsComment(
      id: json['id'] as int,
      name: json['name'] as String? ?? '-',
      datetime: DateTime.parse(json['datetime'] as String),
      comment: json['comment'] as String? ?? '',
      newsId: json['newsId'] as int,
    );
  }
}
