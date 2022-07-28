import 'package:flutter/material.dart';

class PlayerData {
  final score = ValueNotifier<int>(0);
  final health = ValueNotifier<int>(5);
  final key = ValueNotifier<bool>(false);
  final bonusLifePointCount = ValueNotifier<int>(0);
  final toast = ValueNotifier<String>('');
  final toastImage = ValueNotifier<String>('');
  final highScore = ValueNotifier<int>(0);
  final hasBeenNotifiedOfHighScore = ValueNotifier<bool>(false);
  final hasSpawnedHiddenStars = ValueNotifier<bool>(false);
}