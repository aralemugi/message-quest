import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/direction_animations/simple_direction_animation.dart';

class Rabbit extends SimpleNpc with ObjectCollision, AutomaticRandomMovement, Pushable {
  Rabbit(Vector2 position, SpriteSheet spriteSheet,
      {Direction initDirection = Direction.right})
      : super(
    // アニメーションの設定
    animation: SimpleDirectionAnimation(
      idleDown: spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 1, to: 2).asFuture(),
      idleLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.2, from: 1, to: 2).asFuture(),
      idleRight: spriteSheet.createAnimation(row: 2, stepTime: 0.2, from: 1, to: 3).asFuture(),
      idleUp: spriteSheet.createAnimation(row: 3, stepTime: 0.2, from: 1, to: 2).asFuture(),
      runDown: spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 3).asFuture(),
      runLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.2, from: 0, to: 3).asFuture(),
      runRight: spriteSheet.createAnimation(row: 2, stepTime: 0.2, from: 0, to: 3).asFuture(),
      runUp: spriteSheet.createAnimation(row: 3, stepTime: 0.2, from: 0, to: 3).asFuture(),
    ),
    // 表示サイズ、初期位置と方向、移動スピード (歩行時)
    size: Vector2(32, 32),
    position: position,
    initDirection: initDirection,
    speed: 50,
  ) {
    // 当たり判定の設定
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(sizeNpc.x, sizeNpc.y),
            align: Vector2(sizeNpc.x * 1 / 32, sizeNpc.y * 1 / 32),
          ),
        ],
      ),
    );
  }

  static final sizeNpc = Vector2(32, 32);

  @override
  void update(double dt) {

    // if (!_seePlayer) {
    runRandomMovement(
      dt,
      speed: speed,
      maxDistance: (speed * 10).toInt(),
      timeKeepStopped: 500,
    );
    // }

    super.update(dt);
  }
}