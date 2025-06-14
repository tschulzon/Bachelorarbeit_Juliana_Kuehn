import 'package:plantagotchi/models/skin_item.dart';

class OwnedSkin {
  final String id;
  final String userId;
  final SkinItem skin;
  final DateTime aquiredAt;

  OwnedSkin({
    required this.id,
    required this.userId,
    required this.skin,
    required this.aquiredAt,
  });
}
