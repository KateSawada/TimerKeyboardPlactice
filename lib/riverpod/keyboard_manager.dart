import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'key_button.dart';

class KeyboardManager {
  // singleton
  static final KeyboardManager _cache = KeyboardManager._internal();
  factory KeyboardManager() {
    return _cache;
  }
  KeyboardManager._internal();
  // end singleton

  static const int colPerRow = 3;
  List<String> keys = [
    "あ",
    "か",
    "さ",
    "た",
    "な",
    "は",
    "ま",
    "や",
    "ら",
    "-",
    "わ",
    "-",
  ];

  int get keyLength => keys.length;
  int currentFocusIndex = 0;
  int focusPeriod = 1; // 1 second
  late Timer ficusTimer;

  late StateNotifierProvider<CounterNotifier, int> provider;

  void initialize() {
    provider = StateNotifierProvider<CounterNotifier, int>((ref) {
      return CounterNotifier();
    });
  }

  void updateFocus(int new_idx) {
    currentFocusIndex = new_idx;
    print("idx updated: $currentFocusIndex");
  }

  List<GridTile> createKeys() {
    List<GridTile> grid = [];
    for (int i = 0; i < keys.length; i++) {
      grid.add(GridTile(child: KeyButton(keys[i], i)));
    }
    return grid;
  }

  void enableAutoFocus() {}

  void disableAutoFocus() {}
}

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment(int new_idx) {
    state = new_idx;
  }
}
