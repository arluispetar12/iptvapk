class VodItem {
  final String streamId;
  final String name;
  final String cover;
  final String categoryId;
  final String releaseDate;
  final String rating;

  VodItem({
    required this.streamId,
    required this.name,
    required this.cover,
    required this.categoryId,
    required this.releaseDate,
    required this.rating,
  });

  factory VodItem.fromJson(Map<String, dynamic> json) {
    return VodItem(
      streamId: (json['stream_id'] ?? json['series_id'] ?? '').toString(),
      name: json['name'] ?? json['title'] ?? '',
      cover: json['cover'] ?? json['stream_icon'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      releaseDate: json['releaseDate'] ?? json['release_date'] ?? '',
      rating: json['rating']?.toString() ?? '',
    );
  }
}
