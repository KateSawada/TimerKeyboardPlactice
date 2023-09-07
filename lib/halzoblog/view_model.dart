import 'model.dart';

/// ViewModel層のクラス ///////////////////////////////////////////////////
class SampleViewModelO {
  // インスタンスを1つしか生成しないようにするため
  // シングルトン化する
  SampleViewModelO._();
  static final instanceO = SampleViewModelO._();
  // Model層のインスタンスを定義
  SampleModelO modelO = SampleModelO();
  // カウンター変数を定義（初期値は0）
  int countNumberO = 0;
  // View層から受け取った再描画メソッドを代入するFunction型プロパティ
  late Function rebuildWidgetAFromVMO;
  late Function rebuildWidgetBFromVMO;
  late Function rebuildBothFromVMO;
  // WidgetAを再描画するメソッドをViewModel内のプロパティに代入
  void setRebuildMethodAO(Function methodO) {
    rebuildWidgetAFromVMO = methodO;
  }

  // WidgetBを再描画するメソッドをViewModel内のプロパティに代入
  void setRebuildMethodBO(Function methodO) {
    rebuildWidgetBFromVMO = methodO;
  }

  // bodyのWidget全体（＝WidgetAとB両方）を再描画するメソッドをViewModel内のプロパティに代入
  void setRebuildMethodBothO(Function methodO) {
    rebuildBothFromVMO = methodO;
  }

  void countUpForWidgetAO() {
    // カウンター変数をModel層の計算メソッドに渡し、計算結果を返り値で取得
    int calculatedNumberO = modelO.countUpO(countNumberO);
    countNumberO = calculatedNumberO;
    // WidgetAの再描画メソッドを実行
    rebuildWidgetAFromVMO();
  }

  void countUpForWidgetBO() {
    // カウンター変数をModel層の計算メソッドに渡し、計算結果を返り値で取得
    int calculatedNumberO = modelO.countUpO(countNumberO);
    countNumberO = calculatedNumberO;
    // WidgetBの再描画メソッドを実行
    rebuildWidgetBFromVMO();
  }

  void countUpForBothO() {
    // カウンター変数をModel層の計算メソッドに渡し、計算結果を返り値で取得
    int calculatedNumberO = modelO.countUpO(countNumberO);
    countNumberO = calculatedNumberO;
    // bodyのWidget全体（＝WidgetAとBの両方）の再描画メソッドを実行
    rebuildBothFromVMO();
  }
}
