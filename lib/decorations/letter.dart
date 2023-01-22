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
      // アイテム所持数の更新
      if(player.controller.itemCounts[gameItem] == null){
        // mapのnullガード
        player.controller.itemCounts[gameItem] = 0;
      }
      player.controller.itemCounts[gameItem] = player.controller.itemCounts[gameItem]! + 1;

      if(player.controller.itemObtained[map] == null){
        player.controller.itemObtained[map] = {};
      }
      player.controller.itemObtained[map]!.add(id);
      // 画面から消える
      removeFromParent();
    }
  }

  // アイテムがマップに追加された直後に実行される
  @override
  void onMount(){
    if(player.controller.itemObtained[map] != null
    && player.controller.itemObtained[map]!.contains(id)){
      // すでに取得済みであれば削除
      removeFromParent();
    }
    super.onMount();
  }
}
