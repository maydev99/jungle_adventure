import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jungle_adventure/game/game_screen.dart';
import 'package:jungle_adventure/game/jungle_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  await GetStorage.init();
  runApp(const MyApp());
}

final _game = JungleGame();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jungle Adventure',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body:  GameScreen()),
      );

  }
}

