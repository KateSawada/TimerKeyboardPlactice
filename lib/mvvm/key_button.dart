import 'package:flutter/material.dart';
import 'keyboard_manager.dart';

class KeyButton extends StatefulWidget {
  final String _key;
  final int idx;
  const KeyButton(Key key, this._key, this.idx) : super(key: key);

  @override
  KeyButtonState createState() => KeyButtonState();
}

class KeyButtonState extends State<KeyButton> {
  bool isFocused = false;

  // 上位widget(KeyGrid)からこのstateをいじるために関数を用意した
  void updateFocusState(bool newState) {
    setState(() {
      isFocused = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isFocused ? Colors.white : const Color(0xff87cefa),
      child: TextButton(
        onPressed: () {
          // キーを押されたら自身にフォーカスが当たるように，フォーカスの更新関数を呼ぶ
          KeyboardManager().updateFocus(widget.idx);
        },
        child: Center(
            child: Text(
          widget._key,
          style: const TextStyle(fontSize: 46.0),
        )),
      ),
    );
  }
}
