

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jungle_adventure/game/jungle_game.dart';

import '../overlays/pause_overlay.dart';




JungleGame _gameMain = JungleGame();

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
          title: 'AppTitle',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: Scaffold(
            body: GameWidget(
              overlayBuilderMap: {
                PauseOverlay.id: (_, JungleGame gameRef) =>
                    PauseOverlay(gameRef: _gameMain),

              },
              //initialActiveOverlays: const [GameStart.id],
              game: _gameMain,
            ),
          )),
    );
  }
}