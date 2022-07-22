
import 'dart:ui';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jungle_adventure/game/data/player_data.dart';

import 'package:jungle_adventure/game/level/level.dart';
import 'package:jungle_adventure/game/tap_component.dart';
import 'package:jungle_adventure/overlays/game_over_overlay.dart';
import 'package:jungle_adventure/overlays/hud_overlay.dart';
import 'package:jungle_adventure/overlays/toast_overlay.dart';

import '../overlays/pause_overlay.dart';

class JungleGame extends FlameGame
    with HasCollisionDetection, HasTappableComponents, HasTappablesBridge {
  Level? _currentLevel;
  late Image spriteSheet;
  late Image teleporterImage;
  late Image bkgImage;
  late Image items;
  late TapComponent tapComponent;
  late double screenX;
  late double screenY;
  late int score;
  late int high;
  final Timer _toastTimer = Timer(1);
  bool isShowingToast = false;
  final playerData = PlayerData();
  var box = GetStorage();
  late int previousHighScore;

  @override
  Future<void>? onLoad() async {
    //debugMode = true;
    screenX = size.x;
    screenY = size.y;

    bkgImage = await images.load('cloud_bkg.png');
    spriteSheet = await images.load('spritesheet2.png');
    teleporterImage = await images.load('teleporter.png');


    camera.viewport = FixedResolutionViewport(Vector2(600, 300));
    loadLevel('level7.tmx');


    overlays.add(HudOverlay.id);

    previousHighScore = box.read('high_score') ?? 0;

    return super.onLoad();
  }

  @override
  void onMount() {
    tapComponent = TapComponent(size.x, size.y, screenX, screenY);
    add(tapComponent);
    var savedHighScore = box.read('high_score') ?? 0;
    playerData.highScore.value = savedHighScore;


    _toastTimer.onTick = () {
      isShowingToast = false;
    };

    super.onMount();
  }

  @override
  void update(double dt) {
    int lives =  playerData.health.value;
    score = playerData.score.value;
    high = playerData.highScore.value;

    saveHighScore();


    int bonusLifePointCount = playerData.bonusLifePointCount.value;
    if(lives < 1) {
      pauseEngine();
      saveHighScore();
      playerData.hasBeenNotifiedOfHighScore.value = false;
      overlays.add(GameOverOverlay.id);
    }

    if(bonusLifePointCount >= 100) {
      makeAToast('Bonus Life +1');

      playerData.health.value += 1;
      playerData.bonusLifePointCount.value = 0;
    }


    _toastTimer.update(dt);

    if(!isShowingToast) {
      overlays.remove(ToastOverlay.id);
    }


    super.update(dt);
  }

  void saveHighScore() {

    if(score > high) {
      playerData.highScore.value = score;
      }
  }

  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }

  void restartGame() {
    playerData.health.value = 5;
    playerData.key.value = false;
    playerData.score.value = 0;
  }

  void makeAToast(String message) {
    playerData.toast.value = message;
    isShowingToast = true;
    overlays.add(ToastOverlay.id);
    _toastTimer.start();
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
        saveHighScore();
        pauseEngine();
        break;
      case AppLifecycleState.inactive:
        if (overlays.isActive(HudOverlay.id)) {
          overlays.remove(HudOverlay.id);
          overlays.add(PauseOverlay.id);
        }

        pauseEngine();
        saveHighScore();

        break;
    }
    super.lifecycleStateChange(state);
  }
}
