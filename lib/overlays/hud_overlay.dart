import 'package:flutter/material.dart';
import 'package:jungle_adventure/game/jungle_game.dart';
import 'package:jungle_adventure/overlays/pause_overlay.dart';

class HudOverlay extends StatefulWidget {
  static const id = 'HudOverlay';
  final JungleGame gameRef;

  const HudOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  HudOverlayState createState() => HudOverlayState();
}

class HudOverlayState extends State<HudOverlay> {
  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;

    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.score,
                  builder: (context, value, child) {
                    return Text(
                      'Score: ${value.toString()}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.highScore,
                  builder: (context, value, child) {
                    return Text(
                      'High: ${value.toString()}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                gameRef.pauseEngine();
                gameRef.saveHighScore();
                gameRef.overlays.add(PauseOverlay.id);
                gameRef.overlays.remove(HudOverlay.id);
              },
              icon: const Icon(Icons.pause_circle),
              color: Colors.white,
              iconSize: 35,
            ),
            
            Row(
              children: [
                Image.asset('assets/images/star.png'),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.bonusLifePointCount,
                  builder: (context, value, child) {
                    return Text(
                      '${value.toString()} / 100',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.key,
                  builder: (context, value, child) {
                    return value == true
                        ? Image.asset('assets/images/key_24.png')
                        : Image.asset('assets/images/clear_24.png');
                  },
                ),
                Image.asset('assets/images/bonobo_profile_32.png'),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.health,
                  builder: (context, value, child) {
                    return Text(
                      'x${value.toString()}',
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
