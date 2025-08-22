// Class representing a skin item in the app
class SkinItem {
  final String id;
  final String name;
  final int price;
  final String skinUrl;
  final String? skinThirsty;
  final String? skinHungry;

  SkinItem({
    required this.id,
    required this.name,
    required this.price,
    required this.skinUrl,
    this.skinThirsty,
    this.skinHungry,
  });

  // This is the factory method to create a SkinItem object from a JSON map
  factory SkinItem.fromJson(Map<String, dynamic> json) {
    return SkinItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      skinUrl: json['skinUrl'] as String,
      skinThirsty: json['skinThirsty'] as String,
      skinHungry: json['skinHungry'] as String,
    );
  }

  // This is the method to convert the SkinItem object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'skinUrl': skinUrl,
      'skinThirsty': skinThirsty,
      'skinHungry': skinHungry,
    };
  }
}
