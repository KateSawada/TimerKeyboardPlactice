class Receiver {
  Receiver();

  void registerAsReceiver() {
    Sender().addReceiver(this);
  }

  void onReceived(String message) {
    print(message);
  }
}

// KeyboardManagerがこれになる想定
class Sender {
  // singleton化
  static final Sender _cache = Sender._internal();
  factory Sender() {
    return _cache;
  }

  // ここから
  List<Receiver> receivers = [];

  void sendNotify() {
    for (int i = 0; i < receivers.length; i++) {
      receivers[i].onReceived("message");
    }
  }

  void addReceiver(Receiver receiver) {
    receivers.add(receiver);
  }

  // removeReceiverみたいにしなかったのは，receiverの==演算の定義が面倒だったため省略した．
  void clearReceiver() {
    receivers = [];
  }
  // ここまでをKeyboardManagerが持てばOK

  // singleton化
  Sender._internal();
}
