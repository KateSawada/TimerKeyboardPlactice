import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'keyboard_manager.dart';

class KeyButton extends ConsumerWidget {
  final String _key;
  final int idx;
  KeyButton(String this._key, int this.idx);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateController = ref.watch(KeyboardManager().provider.notifier);
    final value = ref.watch(KeyboardManager().provider);
    return Container(
      color: value == idx ? Colors.white : const Color(0xff87cefa),
      child: TextButton(
        onPressed: () {
          print("pressed $_key");
          KeyboardManager().updateFocus(idx);
          stateController.increment(idx);
        },
        child: Center(
            child: Text(
          _key,
          style: const TextStyle(fontSize: 46.0),
        )),
      ),
    );
  }
}
