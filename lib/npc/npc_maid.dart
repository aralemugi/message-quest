import 'dart:io';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/collision/object_collision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:message_quest/maps/start_map.dart';

import '../player/player_beared_dude_controller.dart';

class NpcMaid extends SimpleNpc with ObjectCollision, JoystickListener {
  NpcMaid(Vector2 position, SpriteSheet spriteSheet,
      {Direction initDirection = Direction.down})
      : super(
    // アニメーションの設定
    animation: SimpleDirectionAnimation(
      idleDown: spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 1, to: 2).asFuture(),
      idleLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.2, from: 1, to: 2).asFuture(),
      idleRight:
      spriteSheet.createAnimation(row: 2, stepTime: 0.2, from: 1, to: 2).asFuture(),
      idleUp: spriteSheet.createAnimation(row: 3, stepTime: 0.2, from: 0, to: 2).asFuture(),
      runDown: spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 3).asFuture(),
      runLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.2, from: 0, to: 3).asFuture(),
      runRight: spriteSheet.createAnimation(row: 2, stepTime: 0.2, from: 0, to: 3).asFuture(),
      runUp: spriteSheet.createAnimation(row: 3, stepTime: 0.2, from: 0, to: 3).asFuture(),
    ),
    // 表示サイズ、初期位置と方向、移動スピード (歩行時)
    size: Vector2(32, 32),
    position: position,
    initDirection: initDirection,
    speed: 40*2,
  ) {
    // 当たり判定の設定
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(sizeNpc.x * 32 / 32, sizeNpc.y * 32 / 32),
            align: Vector2(sizeNpc.x *  1 / 32, sizeNpc.y * 1 / 32),
          ),
        ],
      ),
    );
  }

  // StateControllerを取得
  final controller = BonfireInjector().get<BearedDudeController>();

  static final sizeNpc = Vector2(32, 32);
  // 視野の半径
  static const radiusVision = 54.0;
  bool _seePlayer = false;
  bool _isTalked = false;
  bool _havingLetter = false;

  @override
  void update(double dt) {
    super.update(dt);

    // StartMapのアイテム取得状態を参照
    final itemObtained = controller.itemObtained[StartMap];
    _havingLetter = (itemObtained != null && itemObtained.containsAll({0}));

    // Playerとの距離に応じて処理を実行
    seePlayer(
      // 視野の半径
      radiusVision: radiusVision,
      // プレイヤーが視野内にいる時
      observed: (player) {
        if (!_seePlayer) {
          _seePlayer = true;
        }
        _faceToPlayer(player);
      },
      // プレイヤーが視野内にいない時
      notObserved: () {
        if (_seePlayer) {
          _seePlayer = false;
        }
      },
    );

    if(_isTalked){
      // bool _isCollision = false;
      if(!moveRight(20)){
        animation!.play(SimpleAnimationEnum.idleDown);
      }
    }
  }

  // プレイヤーの方向を見る
  void _faceToPlayer(GameComponent player) {
    // プレイヤーとの位置の差
    final displacement = player.center - center;

    // プレイヤーの位置に応じてアニメーションを変更
    if (displacement.x.abs() > displacement.y.abs()) {
      if (0 < displacement.x) {
        animation!.play(SimpleAnimationEnum.idleRight);
      } else {
        animation!.play(SimpleAnimationEnum.idleLeft);
      }
    } else {
      if (0 < displacement.y) {
        animation!.play(SimpleAnimationEnum.idleDown);
      } else {
        animation!.play(SimpleAnimationEnum.idleUp);
      }
    }
  }

  void _showTalkLetterOk() {
    gameRef.camera.moveToTargetAnimated(this); // カメラをNPCに向ける
    TalkDialog.show(
      context,
      // テキストの量だけ`Say()`を配列に追加する
      [
        Say(
          text: [const TextSpan(
              text: '招待状はお持ちでいらっしゃいますでしょうか？',
              style: TextStyle(fontFamily: 'JF-Dot-k12x10', color: Colors.white),
          )], //　表示するテキスト
          personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
          person: SizedBox(
            width: size.x,
            height: size.y,
            child: animation!.idleDown!.asFuture().asWidget(),
          ), // 表示するアニメーション
        ),
        Say(
          text: [const TextSpan(
            text: 'ありがとうございます。確認取れましたので中にお入りください',
            style: TextStyle(fontFamily: 'JF-Dot-k12x10', color: Colors.white),
          )], //　表示するテキスト
          personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
          person: SizedBox(
            width: size.x,
            height: size.y,
            child: animation!.idleDown!.asFuture().asWidget(),
          ), // 表示するアニメーション
        ),
        // 必要な数だけSay()を追加
      ],
      // 会話を次に進めるキーの追加
      logicalKeyboardKeysToNext: [LogicalKeyboardKey.space],
      // テキストのスタイル
      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),

      // 会話終了後にカメラをプレイヤーに戻す
      onFinish: () {
        gameRef.camera.moveToTargetAnimated(gameRef.player!);
        _isTalked = true;
      },
    );
  }

  void _showTalkLetterNg() {
    gameRef.camera.moveToTargetAnimated(this); // カメラをNPCに向ける
    TalkDialog.show(
      context,
      // テキストの量だけ`Say()`を配列に追加する
      [
        Say(
          text: [const TextSpan(
            text: '招待状はお持ちでいらっしゃいますでしょうか？',
            style: TextStyle(fontFamily: 'JF-Dot-k12x10', color: Colors.white),
          )], //　表示するテキスト
          personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
          person: SizedBox(
            width: size.x,
            height: size.y,
            child: animation!.idleDown!.asFuture().asWidget(),
          ), // 表示するアニメーション
        ),
        Say(
          text: [const TextSpan(
            text: '申し訳ありませんが、招待状を持参いただき再度お越しください。',
            style: TextStyle(fontFamily: 'JF-Dot-k12x10', color: Colors.white),
          )], //　表示するテキスト
          personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
          person: SizedBox(
            width: size.x,
            height: size.y,
            child: animation!.idleDown!.asFuture().asWidget(),
          ), // 表示するアニメーション
        ),
      ],
      // 会話を次に進めるキーの追加
      logicalKeyboardKeysToNext: [LogicalKeyboardKey.space],
      // テキストのスタイル
      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),

      // 会話終了後にカメラをプレイヤーに戻す
      onFinish: () {
        gameRef.camera.moveToTargetAnimated(gameRef.player!);
        // _isTalked = true;
      },
    );
  }


  @override
  void joystickAction(JoystickActionEvent event) {

    // // StartMapのアイテム取得状態を参照
    // final itemObtained = controller.itemObtained[StartMap];

    if ((event.id == 1 || event.id == LogicalKeyboardKey.space.keyId) &&
        event.event == ActionEvent.DOWN && _seePlayer) {
      if (_havingLetter) {
        // 招待状を持っていたら
        _showTalkLetterOk();
      } else {
        // 招待状を持っていなかったら
        _showTalkLetterNg();
      }

    }
    super.joystickAction(event);
  }
}