# send receive の実装メモ

まずはミニマムな実装で試したい．

- senderは，適当なsingletonを作って，内部でtimerを動かしてsendを発火させる
- receiverは，適当にwidgets/colored_text.dartを作って，通知を受け取るたびに色が変わるようなものを作る．

結局StatefulWidgetが状態を持てないため，setStateできないことに気づいた．

↓こいつらでどうにかできないか?
- https://atsu-developer.net/1114/
- https://halzoblog.com/setstate-mvvm/
