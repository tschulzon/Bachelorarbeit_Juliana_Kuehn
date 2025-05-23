import 'package:plantagotchi/models/shop_item.dart';

class OwnedSkin {
  final String id;
  final String userId;
  final ShopItem skinId;
  final DateTime aquiredAt;

  OwnedSkin({
    required this.id,
    required this.userId,
    required this.skinId,
    required this.aquiredAt,
  });
}
