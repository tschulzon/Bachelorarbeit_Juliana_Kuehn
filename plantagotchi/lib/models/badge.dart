class PlantBadge {
  final String id;
  final String name;
  final String milestone;
  final String description;
  final String imageUrl;

  PlantBadge({
    required this.id,
    required this.name,
    required this.milestone,
    required this.description,
    required this.imageUrl,
  });

  factory PlantBadge.fromJson(Map<String, dynamic> json) {
    return PlantBadge(
        id: json['id'],
        name: json['name'],
        milestone: json['milestone'],
        description: json['description'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'milestone': milestone,
      'description': description,
      'imageUrl': imageUrl
    };
  }
}
