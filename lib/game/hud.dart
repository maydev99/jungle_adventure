import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:jungle_adventure/game/jungle_game.dart';

class Hud extends Component with HasGameRef<JungleGame> {
  late bool hasKey;
  late var keySprite;

  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  Future<void>? onLoad() {
    hasKey = gameRef.playerData.key.value;

    final scoreTextComponent =
        TextBoxComponent(text: 'Score: 0', position: Vector2.all(5));
    add(scoreTextComponent);

    final healthTextComponent = TextComponent(
      text: 'x5',
      anchor: Anchor.topRight,
      position: Vector2(gameRef.size.x - 10, 10),
    );
    add(healthTextComponent);
    


    keySprite = SpriteComponent.fromImage(
      gameRef.spriteSheet,
      srcPosition: Vector2(32, 32),
      srcSize: Vector2.all(30),
      size: Vector2.all(20),
      anchor: Anchor.topRight,
      position: Vector2(
          healthTextComponent.position.x - healthTextComponent.size.x - 50, 15),
    );
    //add(keySprite);



    /*final pauseButton = SpriteButtonComponent(
      onPressed: () {
        //gameRef.pauseEngine();
        //gameRef.overlays.add(PauseMenu.id);
      },
      button: Sprite(
        gameRef.spriteSheet,
        srcSize: Vector2.all(30),
        srcPosition: Vector2(0, 4 * 32),
      ),
      size: Vector2.all(32),
      anchor: Anchor.topCenter,
      position: Vector2(gameRef.size.x / 2, 5),
    )..positionType = PositionType.viewport;
    add(pauseButton);*/






    final playerSprite = SpriteComponent.fromImage(
      gameRef.spriteSheet,
      srcPosition: Vector2(3 * 32, 2 * 32),
      srcSize: Vector2.all(31),
      anchor: Anchor.topRight,
      position: Vector2(
          healthTextComponent.position.x - healthTextComponent.size.x - 5, 7),
    );
    add(playerSprite);

    gameRef.playerData.score.addListener(() {
      scoreTextComponent.text = 'Score: ${gameRef.playerData.score.value}';
    });

    gameRef.playerData.health.addListener(() {
      healthTextComponent.text = 'x${gameRef.playerData.health.value}';
    });

    gameRef.playerData.key.addListener(() {
      bool hasKey = gameRef.playerData.key.value;
      if(hasKey) {
        add(keySprite);
      } else {
        remove(keySprite);
      }
      
    });

    return super.onLoad();
  }


}
