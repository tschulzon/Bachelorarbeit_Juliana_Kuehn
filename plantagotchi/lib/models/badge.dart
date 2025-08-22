// Class representing a badge in the app
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

  // This is the factory method to create a PlantBadge object from a JSON map
  // We need this to read data from the JSON file and create a Dart object
  factory PlantBadge.fromJson(Map<String, dynamic> json) {
    return PlantBadge(
        id: json['id'],
        name: json['name'],
        milestone: json['milestone'],
        description: json['description'],
        imageUrl: json['imageUrl']);
  }

  // This is the method to convert the PlantBadge object to a JSON map
  // We need this to save something in the database
  // and to read it back, useful if you want to save, transfer, or cache
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
