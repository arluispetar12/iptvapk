class Channel {
  final String streamId;
  final String name;
  final String streamIcon;
  final String categoryId;
  final int num;

  Channel({
    required this.streamId,
    required this.name,
    required this.streamIcon,
    required this.categoryId,
    required this.num,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      streamId: json['stream_id']?.toString() ?? '',
      name: json['name'] ?? '',
      streamIcon: json['stream_icon'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      num: json['num'] ?? 0,
    );
  }
}
