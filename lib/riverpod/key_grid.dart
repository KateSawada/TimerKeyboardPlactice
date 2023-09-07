import 'package:flutter/material.dart';
import 'keyboard_manager.dart';

class KeyGrid extends StatelessWidget {
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
              children: KeyboardManager().createKeys(),
            )));
  }
}
