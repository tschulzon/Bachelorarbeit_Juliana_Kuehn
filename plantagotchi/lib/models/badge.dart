class Badge {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String conditionType;
  final String conditionValue;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.conditionType,
    required this.conditionValue,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      conditionType: json['conditionType'],
      conditionValue: json['conditionValue'],
    );
  }
}
