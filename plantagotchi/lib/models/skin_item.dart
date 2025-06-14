class SkinItem {
  final String id;
  final String name;
  final int price;
  final String skinUrl;

  SkinItem({
    required this.id,
    required this.name,
    required this.price,
    required this.skinUrl,
  });

  factory SkinItem.fromJson(Map<String, dynamic> json) {
    return SkinItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      skinUrl: json['skinUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'skinUrl': skinUrl,
    };
  }
}
