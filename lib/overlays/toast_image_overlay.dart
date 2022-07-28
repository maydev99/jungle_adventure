import 'package:flutter/material.dart';
import 'package:jungle_adventure/game/jungle_game.dart';
import 'package:logger/logger.dart';

class ToastImageOverlay extends StatefulWidget {
  static const id = 'ToastImageOverlay';
  final JungleGame gameRef;

  const ToastImageOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  ToastImageOverlayState createState() => ToastImageOverlayState();
}

class ToastImageOverlayState extends State<ToastImageOverlay> {
  var log = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.1),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.toastImage,
                  builder: (context, value, child) {
                    return Image.asset('assets/images/$value',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,);

                  },
                ),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.toast,
                  builder: (context, value, child) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}