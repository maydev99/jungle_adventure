import 'dart:ui';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:jungle_adventure/game/data/player_data.dart';

import 'package:jungle_adventure/game/level/level.dart';
import 'package:jungle_adventure/game/tap_component.dart';
import 'package:jungle_adventure/overlays/hud_overlay.dart';

import '../overlays/pause_overlay.dart';

class JungleGame extends FlameGame
    with HasCollisionDetection, HasTappableComponents, HasTappablesBridge {
  Level? _currentLevel;
  late Image spriteSheet;
  late Image items;
  late TapComponent tapComponent;
  late double screenX;
  late double screenY;
  final playerData = PlayerData();

  @override
  Future<void>? onLoad() async {
    //debugMode = true;
    screenX = size.x;
    screenY = size.y;

    spriteSheet = await images.load('spritesheet2.png');

    camera.viewport = FixedResolutionViewport(Vector2(600, 300));
    loadLevel('level4.tmx');


    overlays.add(HudOverlay.id);

    return super.onLoad();
  }

  @override
  void onMount() {
    tapComponent = TapComponent(size.x, size.y, screenX, screenY);
    add(tapComponent);

    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!(overlays.isActive(PauseOverlay.id)) &&
            !(overlays.isActive(PauseOverlay.id))) {
          resumeEngine();
        }

        break;
      case AppLifecycleState.paused:


        break;
      case AppLifecycleState.detached:
        overlays.add(PauseOverlay.id);
        pauseEngine();
        break;
      case AppLifecycleState.inactive:
        if (overlays.isActive(HudOverlay.id)) {
          overlays.remove(HudOverlay.id);
          overlays.add(PauseOverlay.id);
        }

        pauseEngine();

        break;
    }
    super.lifecycleStateChange(state);
  }
}
