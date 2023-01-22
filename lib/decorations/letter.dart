import 'package:bonfire/bonfire.dart';
import 'package:message_quest/model/game_item.dart';

import '../player/player_beared_dude.dart';



class LetterDecoration extends GameDecoration with Sensor {
  LetterDecoration(
      {required this.initPosition, required this.map, required this.id, required this.player})
      : super.withSprite(
    sprite: Sprite.load(gameItem.imagePath),
    position: initPosition,
    size: Vector2(48, 48),
  ) {
    setupSensorArea(areaSensor: [
      CollisionArea.rectangle(size: size, align: Vector2.zero()),
    ]);
  }
  static final gameItem = Letter(); // アイテムクラス

  final Vector2 initPosition; // 初期
  final Type map; // 配置されているマップ
  final int id; // マップ中のアイテムのID番号
  final PlayerBeardedDude player; // 取得するプレイヤーキャラクター

  @override
  void onContact(GameComponent component) {
    // プレイヤーが接触したら
    if (component is PlayerBeardedDude) {
      // 画面から消える
      removeFromParent();
    }
  }
}
