import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:jungle_adventure/game/actors/background.dart';
import 'package:jungle_adventure/game/actors/background2.dart';
import 'package:jungle_adventure/game/actors/bonus_platform.dart';
import 'package:jungle_adventure/game/actors/hidden_stars.dart';
import 'package:jungle_adventure/game/actors/moving_platform.dart';
import 'package:jungle_adventure/game/actors/player.dart';
import 'package:jungle_adventure/game/actors/star.dart';
import 'package:jungle_adventure/game/actors/teleporter.dart';
import 'package:jungle_adventure/game/jungle_game.dart';
import 'package:tiled/tiled.dart';

import '../actors/door.dart';
import '../actors/enemy.dart';
import '../actors/key.dart';
import '../actors/platform.dart';

class Level extends Component with HasGameRef<JungleGame> {
  final String levelName;
  late Player player;
  late Rect levelBounds;
  late BackgroundComponent backgroundComponent;
  var hasSpawnedHiddenStars = false;

  Level(this.levelName) : super();


  @override
  Future<void>? onLoad() async {
    hasSpawnedHiddenStars = gameRef.playerData.hasSpawnedHiddenStars.value;
    final level = await TiledComponent.load(levelName, Vector2.all(32));
    backgroundComponent = BackgroundComponent();



    levelBounds = Rect.fromLTWH(
        0,
        0,
        (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
        (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble());

    await add(level);
    await spawnActors(level.tileMap);

    await setupCamera();

    return super.onLoad();
  }




  spawnActors(RenderableTiledMap tileMap) async{


    final platformsLayer = tileMap.getLayer<ObjectGroup>('PlatformsLayer');

    for (final platformObject in platformsLayer!.objects) {
      final platform = Platform(
        position: Vector2(platformObject.x, platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }


    final spawnPointsLayer = tileMap.getLayer<ObjectGroup>('SpawnLayer');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      final position = Vector2(spawnPoint.x, spawnPoint.y - spawnPoint.height);
      final size = Vector2(spawnPoint.width, spawnPoint.height);
      switch (spawnPoint.name) {
        case 'Player':
          player = Player(gameRef.spriteSheet,
              anchor: Anchor.center,
              levelBounds: levelBounds,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: size);
          add(player);
          break;

        case 'Star':
          final star =
              Star(gameRef.spriteSheet, position: position, size: size);
          add(star);
          break;

        case 'Door':
          final door = Door(gameRef.spriteSheet, position: position, size: size,
              onPlayerEnter: () {
            gameRef.loadLevel(spawnPoint.properties.first.value);
          });

          add(door);
          break;


        case 'Teleporter':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final teleporter = Teleporter(gameRef.teleporterImage,
              position: position, size: size, onPlayerEnter: () {
            final target = spawnPointsLayer.objects
                .firstWhere((object) => object.id == targetObjectId);
            player.teleportToPosition(Vector2(target.x, target.y));
          });
          add(teleporter);
          break;

        case 'Key':
          final key = Key(
            gameRef.spriteSheet,
            position: position,
            size: size,
          );
          add(key);
          break;

        case 'Enemy':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final target = spawnPointsLayer.objects
              .firstWhere((object) => object.id == targetObjectId);
          final enemy = Enemy(gameRef.spriteSheet,
              position: position,
              targetPosition: Vector2(target.x, target.y),
              size: size);
          add(enemy);
          break;

        case 'MovingPlatform':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final target = spawnPointsLayer.objects
              .firstWhere((object) => object.id == targetObjectId);
          final movingPlatform = MovingPlatform(gameRef.spriteSheet,
              position: position,
              targetPosition: Vector2(target.x, target.y),
              size: size);
          add(movingPlatform);
          break;

        case 'BonusPlatform':
          final bonusPlatform = BonusPlatform(gameRef.spriteSheet,
          position: position,
          size: size);
          add(bonusPlatform);
          break;
      }
    }
  }


  setupCamera() {
    gameRef.camera.followComponent(player);
    gameRef.camera.worldBounds = levelBounds;
  }

}
