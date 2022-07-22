

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import '../jungle_game.dart';

class BackgroundComponent extends Component with HasGameRef<JungleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait([
          gameRef.loadParallaxLayer(
            ParallaxImageData('cloud_bkg.png'),
            velocityMultiplier: Vector2(0.0, 1.0),
            alignment: Alignment.bottomCenter,
            fill: LayerFill.height,

          ),
          /*       loadParallaxLayer(
            ParallaxImageData('backgrounds/Waves.png'),
            velocityMultiplier: Vector2(0.0, 1.0),
            alignment: Alignment.bottomLeft,
            fill: LayerFill.width,
          ),*/
        ]),
        baseVelocity: Vector2(20, 0),
      ),
    );
    add(parallax);
  }
}