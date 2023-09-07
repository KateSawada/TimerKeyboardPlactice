import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'key_grid.dart';
import 'keyboard_manager.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KeyboardManager().initialize(); // KeyboardManagerの初期化. 実際はアプリ起動時に行いたい．
    return ProviderScope(
        child: MaterialApp(
      title: "setState and MVVM Demo",
      theme: ThemeData.light(),
      home: HomePage(),
    ));
  }
}

// final helloWorldProvider = Provider((_) => 'Hello world');

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: KeyGrid(),
    );
  }
}
