import 'package:flutter/material.dart';
import '../utils/notifier.dart';
import '../controllers/keyboard_manager.dart';

class KeyGrid extends StatelessWidget implements Receiver {
  // stateless
  final List<KeyButton> keys = [];

  KeyGrid() {
    registerAsReceiver();
  }

  @override
  void registerAsReceiver() {
    KeyboardManager().addReceiver(this);
  }

  @override
  void onReceived(String message) {
    for (int i = 0; i < KeyboardManager().keyLength; i++) {
      if (i == KeyboardManager().currentFocusIndex) {
        keys[i].updateFocusedColor(true);
      } else {
        keys[i].updateFocusedColor(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(data)
  }
}


class KeyButton extends StatefulWidget {
  String _key = "";
  int idx = 0;
  bool isFocused = false;

  KeyButton(String key, int idx) {
    _key = key;
    idx = idx;
  }

  @override
  State<KeyButton> createState() => _KeyButtonState();

  void hoge (){
    isFocused = true;
  }
}

class _KeyButtonState extends State<KeyButton> {

  void updateFocusedColor(bool focused) {
    setState(() {
      widget.isFocused = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isFocused ? Colors.red : Colors.pink,
      child: TextButton(
        onPressed: () {},
        child: Center(
          child: Text(widget._key),
        ),
      ),
    );
  }
}
