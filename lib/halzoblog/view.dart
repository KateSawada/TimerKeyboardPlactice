import 'package:flutter/material.dart';

import 'view_model.dart';

/// View層 ///////////////////////////////////////////////////
class SampleScreenO extends StatefulWidget {
  @override
  _SampleScreenOState createState() => _SampleScreenOState();
}

class _SampleScreenOState extends State<SampleScreenO> {
  @override
  Widget build(BuildContext context) {
    debugPrint("全体を描画");
    return Scaffold(
      appBar: AppBar(title: AppBarWidgetO()),
      body: BodyWidgetO(),
    );
  }
}

// AppBar部分のクラス
// AppBarを再描画しない場合は、StatelessWidgetでも良い
class AppBarWidgetO extends StatefulWidget {
  const AppBarWidgetO({Key? key}) : super(key: key);
  @override
  _AppBarWidgetOState createState() => _AppBarWidgetOState();
}

class _AppBarWidgetOState extends State<AppBarWidgetO> {
  @override
  Widget build(BuildContext context) {
    debugPrint("AppBarを描画");
    // テキストボタンのスタイルを設定
    ButtonStyle buttonStyleO = ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).primaryColorLight));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // WidgetAを更新するボタン
        TextButton(
          child: Text("Aを更新", style: Theme.of(context).textTheme.button),
          style: buttonStyleO,
          onPressed: () {
            // ボタンを押したら、ViewModel内のWidgetAのカウンターを加算表示するメソッドを実行
            // ※ViewModelはシングルトン化しており、staticのインスタンス経由でアクセスするため、
            //  クラス名.インスタンス名.メソッド名で書く
            SampleViewModelO.instanceO.countUpForWidgetAO();
          },
        ),
        // WidgetBを更新するボタン
        TextButton(
          child: Text("Bを更新", style: Theme.of(context).textTheme.button),
          style: buttonStyleO,
          onPressed: () {
            // ボタンを押したら、ViewModel内のWidgetBのカウンターを加算表示するメソッドを実行
            SampleViewModelO.instanceO.countUpForWidgetBO();
          },
        ),
        // bodyのWidget全体（＝WidgetAとB両方）を更新するボタン
        TextButton(
          child: Text("両方更新", style: Theme.of(context).textTheme.button),
          style: buttonStyleO,
          onPressed: () {
            // ボタンを押したら、ViewModel内のWidgetAとB両方のカウンターを加算表示するメソッドを実行
            SampleViewModelO.instanceO.countUpForBothO();
          },
        ),
      ],
    );
  }
}

// body部分のウィジェット
class BodyWidgetO extends StatefulWidget {
  const BodyWidgetO({Key? key}) : super(key: key);
  @override
  State<BodyWidgetO> createState() => _BodyWidgetOState();
}

class _BodyWidgetOState extends State<BodyWidgetO> {
  // bodyのWidget全体（＝WidgetAとBの両方）を再描画するメソッドを定義
  void rebuildBothWidgetsO() {
    setState(() {});
  }

  @override
  void initState() {
    // ViewModel内に、上記で定義した再描画メソッドを渡す
    SampleViewModelO.instanceO.setRebuildMethodBothO(rebuildBothWidgetsO);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BodyWidgetAO(),
          BodyWidgetBO(),
        ],
      ),
    );
  }
}

// WidgetAのクラス
class BodyWidgetAO extends StatefulWidget {
  const BodyWidgetAO({Key? key}) : super(key: key);
  @override
  _BodyWidgetAOState createState() => _BodyWidgetAOState();
}

class _BodyWidgetAOState extends State<BodyWidgetAO> {
  // WidgetAを再描画するメソッドを定義
  void rebuildWidgetAO() {
    setState(() {});
  }

  @override
  void initState() {
    // ViewModel内に、上記で定義した再描画メソッドを渡す
    SampleViewModelO.instanceO.setRebuildMethodAO(rebuildWidgetAO);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("WidgetAを描画");
    // ViewModel内のカウンター変数を参照して表示
    int displayNumberO = SampleViewModelO.instanceO.countNumberO;
    return Text("WidgetA\nCount\n$displayNumberO", textAlign: TextAlign.center);
  }
}

// WidgetBのクラス
class BodyWidgetBO extends StatefulWidget {
  const BodyWidgetBO({Key? key}) : super(key: key);
  @override
  _BodyWidgetBOState createState() => _BodyWidgetBOState();
}

class _BodyWidgetBOState extends State<BodyWidgetBO> {
  // WidgetBを再描画するメソッドを定義
  void rebuildWidgetBO() {
    setState(() {});
  }

  @override
  void initState() {
    // ViewModel内に、上記で定義した再描画メソッドを渡す
    SampleViewModelO.instanceO.setRebuildMethodBO(rebuildWidgetBO);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("WidgetBを描画");
    // ViewModel内のカウンター変数を参照して表示
    int displayNumberO = SampleViewModelO.instanceO.countNumberO;
    return Text("WidgetB\nCount\n$displayNumberO", textAlign: TextAlign.center);
  }
}
