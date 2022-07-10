import 'package:flutter/material.dart';

class PlayerData {
  final score = ValueNotifier<int>(0);
  final health = ValueNotifier<int>(5);
  final key = ValueNotifier<bool>(false);
}