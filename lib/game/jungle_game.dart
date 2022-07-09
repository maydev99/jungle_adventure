import 'dart:ui';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:jungle_adventure/game/level.dart';
import 'package:jungle_adventure/game/tap_component.dart';


class JungleGame extends FlameGame with HasCollisionDetection, HasTappableComponents {
  Level? _currentLevel;
  late Image spriteSheet;
  late TapComponent tapComponent;
  late double screenX;
  late double screenY;

  @override
  Future<void>? onLoad() async {
    //debugMode = true;
    screenX = size.x;
    screenY = size.y;


    spriteSheet = await images.load('spritesheet2.png');
    camera.viewport = FixedResolutionViewport(Vector2(600,300));
    loadLevel('level1.tmx');


    return super.onLoad();
  }

  @override
  void onMount() {
    tapComponent = TapComponent(size.x, size.y, screenX, screenY);
    add(tapComponent);
    super.onMount();
  }


  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}