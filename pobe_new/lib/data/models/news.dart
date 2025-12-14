class News {
  const News({
    required this.id,
    required this.title,
    required this.author,
    required this.datetime,
    required this.content,
    required this.views,
    required this.up,
    required this.image,
    required this.category,
  });

  final int id;
  final String title;
  final String author;
  final String datetime;
  final String content;
  final String views;
  final String up;
  final String image;
  final String category;

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title: json['title'] as String? ?? '-',
      author: json['author'] as String? ?? '-',
      datetime: json['datetime'] as String? ?? '',
      content: json['content'] as String? ?? '',
      views: json['views']?.toString() ?? '0',
      up: json['up']?.toString() ?? '0',
      image: json['image'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
