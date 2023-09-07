import 'keyboard_base.dart';

class JapaneseKeyboard implements KeyboardBase {
  List<String> keys = [];
  List<String> thumbnails = [];
  JapaneseKeyboard() {
    keys = [
      "あいうえお",
      "かきくけこ",
      "さしすせそ",
      "たちつてと",
      "なにぬねの",
      "はひふへほ",
      "まみむめも",
      "やゆよ",
      "らりるれろ",
      "。、",
      "わをん",
      "!?"
    ];
    thumbnails = [
      "あ",
      "か",
      "さ",
      "た",
      "な",
      "は",
      "ま",
      "や",
      "ら",
      "。",
      "わ",
      "!",
    ];
  }
}
