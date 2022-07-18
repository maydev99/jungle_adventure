import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends PositionComponent with CollisionCallbacks {
  Platform({
    required Vector2? position,
    required Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    Iterable<Component>? children,
    int? priority,
  }) : super(
      position: position,
      size: size,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority
  );

  @override
  Future<void>? onLoad() {
    //debugMode = true;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }
}