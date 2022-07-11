import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:jungle_adventure/game/actors/player.dart';
import 'package:jungle_adventure/game/jungle_game.dart';

// Represents a door in the game world.
class Door extends SpriteComponent with CollisionCallbacks, HasGameRef<JungleGame> {
  Function? onPlayerEnter;

  Door(
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
    srcPosition: Vector2(3 * 32, 3 * 32),
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

      if(gameRef.playerData.key.value) {
        other.removeFromParent();
        onPlayerEnter?.call();
        gameRef.playerData.key.value = false;
      } else {
        print('Door is locked');
      }


    }
    super.onCollisionStart(intersectionPoints, other);
  }
}