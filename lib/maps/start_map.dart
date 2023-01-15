import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

import '../player/player_beared_dude.dart';
import '../player/player_sprite.dart';

class StartMap extends StatefulWidget {
  const StartMap({Key? key}) : super(key: key);
  @override
  State<StartMap> createState() => _StartMapState();
}

class _StartMapState extends State<StartMap> {
  final tileHeightSize = 32.0;
  final tileWidthSize = 25.0; // タイルのサイズ定義

  @override
  Widget build(BuildContext context) {
    // ゲーム画面Widget
    return BonfireWidget(
      showCollisionArea: true, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(
        'maps/new_start_map.json',
        forceTileSize: Vector2(tileWidthSize, tileHeightSize),
      ),

      // プレイヤーキャラクター
      player: PlayerBeardedDude(
        Vector2(tileWidthSize * 12, tileHeightSize * 30),
        // Vector2(32,32),
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