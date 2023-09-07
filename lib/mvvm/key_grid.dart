import 'package:flutter/material.dart';
import 'keyboard_manager.dart';
import 'key_button.dart';

class KeyGrid extends StatefulWidget {
  const KeyGrid({Key? key}) : super(key: key);

  @override
  KeyGridState createState() => KeyGridState();
}

class KeyGridState extends State<KeyGrid> {
  //上位widget(KeyGrid)から下位widget(KeyButton)のstateをいじるために必要．
  List<GlobalKey<KeyButtonState>> buttonKeys = [];

  KeyGridState() {
    for (int i = 0; i < KeyboardManager().keys.length; i++) {
      buttonKeys.add(GlobalKey<KeyButtonState>());
    }
    // KeyGridがもつ，KeyButton再描画の関数をKeyboardManagerに登録する
    KeyboardManager().setRebuildKeyGrid(updateButtonsState);
  }

  List<GridTile> createKeys() {
    List<GridTile> buttons = [];
    for (int i = 0; i < KeyboardManager().keyLength; i++) {
      // GlobalKeyを使って，KeyGridからKeyButtonのstateをいじれるようにする
      KeyButton button =
          KeyButton(buttonKeys[i], KeyboardManager().thumbnails[i], i);

      buttons.add(GridTile(child: button));
    }
    return buttons;
  }

  // KeyButtonを再描画する関数．KeyboardManagerに渡して実行してもらう．
  void updateButtonsState() {
    for (int i = 0; i < buttonKeys.length; i++) {
      buttonKeys[i]
          .currentState
          ?.updateFocusState(i == KeyboardManager().currentFocusIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
            color: const Color(0xff87cefa),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
              childAspectRatio: 1.4,
              children: createKeys(),
            )));
  }
}
