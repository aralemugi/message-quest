import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:message_quest/npc/groom_sprite.dart';
import 'package:message_quest/npc/npc_bride.dart';
import 'package:message_quest/npc/npc_groom.dart';

import '../npc/bride_sprite.dart';
import '../player/player_beared_dude.dart';
import '../player/player_sprite.dart';

class RoomMap extends StatefulWidget {
  const RoomMap({Key? key}) : super(key: key);
  @override
  State<RoomMap> createState() => _RoomMapState();
}

class _RoomMapState extends State<RoomMap> {
  final tileHeightSize = 40.0;
  final tileWidthSize = 40.0; // タイルのサイズ定義

  @override
  Widget build(BuildContext context) {

    late NpcGroom npcGroom;
    late NpcBride npcBride;

    // ゲーム画面Widget
    return BonfireWidget(

      onReady: (game) {
        // _addGameItems(game);
        game.addJoystickObserver(npcGroom);
        game.addJoystickObserver(npcBride);
      },

      showCollisionArea: false, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(

          'maps/map2.json',
          forceTileSize: Vector2(tileWidthSize, tileHeightSize),

          objectsBuilder: {
            'groom': ((properties) {
              npcGroom = NpcGroom(
                  properties.position,
                  GroomSprite.sheet
              );
              return npcGroom;
            }),

            'bride': ((properties) {
              npcBride = NpcBride(
                  properties.position,
                  BrideSprite.sheet
              );
              return npcBride;
            }),
          }
      ),

      // プレイヤーキャラクター
      player: PlayerBeardedDude(
        Vector2(tileWidthSize * 23, tileHeightSize * 22),
        spriteSheet: PlayerSpriteSheet.all,
        initDirection: Direction.left,
      ),
      // カメラ設定
      cameraConfig: CameraConfig(
        // zoom: 1.2,
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