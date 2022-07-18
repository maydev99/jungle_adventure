import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tiled/tiled.dart';

class Background extends SpriteComponent {
  Background(
    Image image, {
    required Vector2? position,
    required Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    Iterable<Component>? children,
    int? priority,
  }) : super.fromImage(image,
            position: position,
            size: size,
            scale: scale,
            angle: angle,
            anchor: anchor,
            priority: priority);
}
