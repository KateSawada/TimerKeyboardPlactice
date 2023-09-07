import 'dart:async';
import 'japanese_keyboard.dart';
import 'keyboard_base.dart';

class KeyboardManager {
  // singleton
  static final KeyboardManager _cache = KeyboardManager._internal();
  factory KeyboardManager() {
    return _cache;
  }
  KeyboardManager._internal();
  // end singleton

  List<KeyboardBase> keyboards = [];

  // currentFocusIndexを秘匿する
  int _currentFocusIndex = 0;
  int get currentFocusIndex => _currentFocusIndex;

  int focusPeriod = 1; // 1 second
  late Timer timer;

  // 現在選択中のキーボードに関する情報
  int currentKeyboardIndex = 0;
  int get keyLength => keyboards[currentKeyboardIndex].keys.length;
  List<String> get keys => keyboards[currentKeyboardIndex].keys;
  List<String> get thumbnails => keyboards[currentKeyboardIndex].thumbnails;

  // widgetを書き換える関数を外部から受け取る
  // 空の関数で初期化しておく
  Function rebuildKeyGrid = () {};
  void setRebuildKeyGrid(Function function) {
    // widgetを書き換える関数を実際に格納
    rebuildKeyGrid = function;
  }

  void initialize() {
    // とりあえず一個だけ格納
    // 実際の運用では，ここに英語など他のキーボードも格納する．
    // キーボードの切り替えは，currentKeyboardIndexで管理する
    keyboards.add(JapaneseKeyboard());
  }

  void moveFocusNext() {
    _currentFocusIndex =
        _currentFocusIndex + 1 >= keyLength ? 0 : _currentFocusIndex + 1;
    updateFocus(_currentFocusIndex);
  }

  // フォーカスが当たっているキーを変更する関数．
  void updateFocus(int newIdx) {
    _currentFocusIndex = newIdx;
    print("idx updated: $_currentFocusIndex");
    // KeyButtonの再描画の関数を実行．
    rebuildKeyGrid();
  }

  void enableAutoFocus() {
    timer = Timer.periodic(Duration(seconds: focusPeriod), (timer) {
      moveFocusNext();
    });
  }

  void disableAutoFocus() {
    timer.cancel();
  }
}
