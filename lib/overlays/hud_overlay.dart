import 'package:flutter/material.dart';
import 'package:jungle_adventure/game/jungle_game.dart';

class HudOverlay extends StatefulWidget {
  const HudOverlay({Key? key, required this.gameRef}) : super(key: key);
  static const id = 'HudOverlay';
  final JungleGame gameRef;


  @override
  HudOverlayState createState() => HudOverlayState();
}

class HudOverlayState extends State<HudOverlay> {

  //Variables and functions


  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appbar Tile here'),
      ),
    );
  }
}