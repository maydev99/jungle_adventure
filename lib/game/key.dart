import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:jungle_adventure/game/player.dart';

// Represents a Key in the game world.
class Key extends SpriteComponent with CollisionCallbacks {
  Function? onPlayerEnter;

  Key(
      Image image, {
        this.onPlayerEnter,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
      }) : super.fromImage(
    image,
    srcPosition: Vector2(3 * 32, 0),
    srcSize: Vector2.all(32),
    position: position,
    size: size,
    scale: scale,
    angle: angle,
    anchor: anchor,
    priority: priority,
  );

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      // onPlayerEnter?.call();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}