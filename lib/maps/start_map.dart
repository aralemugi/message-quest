import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:message_quest/decorations/letter.dart';
import 'package:message_quest/maps/room_map.dart';
import 'package:message_quest/mob/cat.dart';
import 'package:message_quest/mob/cat_sprite.dart';
import 'package:message_quest/npc/maid_sprite.dart';
import 'package:message_quest/npc/npc_maid.dart';
import 'package:message_quest/utilities/exit_map_sensor.dart';

import '../player/player_beared_dude.dart';
import '../player/player_sprite.dart';

class StartMap extends StatefulWidget {
  const StartMap({Key? key}) : super(key: key);
  @override
  State<StartMap> createState() => _StartMapState();
}

class _StartMapState extends State<StartMap> {
  final tileSize = 40.0;

  void _addGameItems(BonfireGame game) {
    // キノコ１つ目
    game.add(
      LetterDecoration(
        initPosition: Vector2(tileSize * 6, tileSize * 23),
        map: widget.runtimeType,
        id: 0,
        player: game.player! as PlayerBeardedDude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    late Cat cat;
    late NpcMaid npcMaid;

    // ゲーム画面Widget
    return BonfireWidget(

      onReady: (game) {
        _addGameItems(game);
        game.addJoystickObserver(npcMaid);
      },

      showCollisionArea: false, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(

        'maps/new_start_map.json',
        forceTileSize: Vector2(tileSize, tileSize),

        objectsBuilder: {
          'toRoomSensor': ((properties) => ExitMapSensor(
              position: properties.position,
              size: properties.size,
              nextMap: const RoomMap())
          ),
          'maid': ((properties) {
            npcMaid = NpcMaid(
                properties.position,
                MaidSprite.sheet
            );
            return npcMaid;
          }),
          'cat':(properties){
            cat = Cat(
                properties.position,
                CatSprite.sheet
            );
            return cat;
          },
        }
      ),

      // プレイヤーキャラクター
      player: PlayerBeardedDude(
        Vector2(tileSize * 12, tileSize * 30),
        spriteSheet: PlayerSpriteSheet.all,
        initDirection: Direction.down,
      ),
      // カメラ設定
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        sizeMovementWindow: Vector2.zero(),
        smoothCameraEnabled: true,
        smoothCameraSpeed: 10,
      ),

      // 入力インターフェースの設定
      joystick: Joystick(
        // 画面上のジョイスティック追加
        directional: JoystickDirectional(
          color: Colors.white,
        ),
        actions: [
          // 画面上のアクションボタン追加
          JoystickAction(
            color: Colors.white,
            actionId: 1,
            margin: const EdgeInsets.all(65),
          ),
        ],
        // キーボード用入力の設定
        keyboardConfig: KeyboardConfig(
          keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows, // キーボードの矢印とWASDを有効化
          acceptedKeys: [LogicalKeyboardKey.space], // キーボードのスペースバーを有効化
        ),
      ),
      // ロード中の画面の設定
      progress: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.black,
      ),
    );
  }
}