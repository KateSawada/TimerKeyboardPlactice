import 'package:flutter/material.dart';
import 'view.dart';

// クラス名、メソッド名、プロパティ名（変数名）について、筆者が作成したもの（名前変更可のもの）
// の名前の末尾には、大文字のオー「O」をつけています
// ※ライブラリ（パッケージ）で予め決められているもの（名前の変更不可のもの）と、
//  自分で作成したもの（名前の変更可のもの）の区別をしやすくするため

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "setState and MVVM Demo",
      theme: ThemeData.light(),
      home: SampleScreenO(),
    );
  }
}
