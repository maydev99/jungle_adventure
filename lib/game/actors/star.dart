
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/animation.dart';
import 'package:jungle_adventure/game/jungle_game.dart';
import 'package:jungle_adventure/game/actors/player.dart';


class Star extends SpriteComponent
    with CollisionCallbacks, HasGameRef<JungleGame> {
  Star(
      Image image, {
        Vector2? srcPosition,
        Vector2? srcSize,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
      }) : super.fromImage(image,
      srcPosition: Vector2(2 * 33, 3 * 32),
      srcSize: Vector2.all(29),
      position: position,
      size: size,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority);

  @override
  Future<void>? onLoad() async {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    add(
      MoveEffect.by(
        Vector2(0, -10),
        EffectController(
          alternate: true,
          infinite: true,
          duration: 1,
          curve: Curves.ease,
        ),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      add(
        OpacityEffect.fadeOut(LinearEffectController(0.3), onComplete: () {
          add(RemoveEffect());
        }),
      );

      gameRef.playerData.score.value += 5;
      gameRef.playerData.bonusLifePointCount.value += 5;
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}