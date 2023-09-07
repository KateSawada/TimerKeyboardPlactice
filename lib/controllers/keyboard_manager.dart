import 'dart:async';
import '../utils/notifier.dart';

class KeyboardManager implements Sender {
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

  @override
  List<Receiver> receivers = [];

  int get keyLength => keys.length;
  int currentFocusIndex = 0;
  int focusPeriod = 1; // 1 second
  late Timer ficusTimer;

  @override
  void sendNotify() {
    for (int i = 0; i < receivers.length; i++) {
      receivers[i].onReceived("update");
    }
  }

  @override
  void addReceiver(Receiver receiver) {
    receivers.add(receiver);
  }

  @override
  void clearReceiver() {
    receivers = [];
  }

  void enableAutoFocus() {}

  void disableAutoFocus() {}
}
