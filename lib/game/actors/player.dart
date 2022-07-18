

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:jungle_adventure/game/actors/moving_platform.dart';
import 'package:jungle_adventure/game/actors/platform.dart';
import 'package:jungle_adventure/game/jungle_game.dart';



class Player extends SpriteComponent with CollisionCallbacks, KeyboardHandler, HasGameRef<JungleGame> {
  int _hAxisInput = 0;
  bool _jumpInput = false;
  bool _isOnGround = false;
  final Vector2 _velocity = Vector2.zero();
  final double _moveSpeed = 100;
  final double _gravity = 10;
  final double _jumpSpeed = 300;
  final Vector2 _up = Vector2(0, -1);
  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  Player(
      Image image, {
        required Rect levelBounds,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
      }) : super.fromImage(
    image,
    srcPosition: Vector2(3 * 32, 2 * 32),
    srcSize: Vector2.all(31),
    position: position,
    size: size,
    scale: scale,
    angle: angle,
    anchor: anchor,
    priority: priority,
  ) {
    // Since anchor point for player is at the center,
    // min and max clamp limits will have to be adjusted by
    // half-size of player.
    final halfSize = size! / 2;
    _minClamp = levelBounds.topLeft.toVector2() + halfSize;
    _maxClamp = levelBounds.bottomRight.toVector2() - halfSize;
  }

  @override
  Future<void>? onLoad() {
    //debugMode = true;
    add(CircleHitbox());
    return super.onLoad();

  }

  @override
  void onMount() {
    gameRef.tapComponent.connectPLayer(this);
    super.onMount();
  }

  @override
  void update(double dt) {
    _velocity.x = _hAxisInput * _moveSpeed;
    _velocity.y += _gravity;

   // print(_velocity.y);

    if(_velocity.y < _gravity) {
      _isOnGround = false;
    }


    if (_jumpInput) {
      if (_isOnGround) {
        _velocity.y = -_jumpSpeed;
        _isOnGround = false;
      }

      _jumpInput = false;
    }

    _velocity.y = _velocity.y.clamp(-_jumpSpeed, 150);

    position += _velocity * dt;

    position.clamp(_minClamp, _maxClamp);

    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    super.update(dt);
  }



/*  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print('key event');
    _hAxisInput = 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }*/

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) +
            intersectionPoints.elementAt(1)) /
            2;
        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        position += collisionNormal.scaled(separationDistance);
      }
    }

    if(other is MovingPlatform) {
      double centerPlatformWidth = other.width / 2;
      position.x = other.position.x + centerPlatformWidth;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if(other is Platform) {
      _isOnGround = false;
    }
    super.onCollisionEnd(other);
  }

  void hit() {
    add(OpacityEffect.fadeOut(
        EffectController(alternate: true, duration: 0.1, repeatCount: 5)));
  }

  // Setter for horizontal input.
  set hAxisInput(int value) {
    _hAxisInput = value;
  }

  // Setter for jump input.
  set jump(bool value) {
    _jumpInput = value;
  }

 /* void jump() {
    if(_isOnGround) {
      _jumpInput = true;
      _isOnGround = false;
    }

  }*/

  void stopJump() {
    if(_isOnGround) {
      _velocity.x = 0;
      _velocity.y = 0;
    }
  }

  void teleportToPosition(Vector2 destination) {
    position = Vector2(destination.x, destination.y);
    _velocity.x = 0;
  }

}



