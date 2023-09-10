import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//import 'package:shared_preferences/shared_preferences.dart';

/// アプリ内全体で共有するBluetoothデバイスのデータを管理する
/// 共有には lobal singleton を使っている
/// https://qiita.com/meltyyyyy/items/b931f0fbdef26038fdbe
/// https://flutter.keicode.com/basics/data-store-singleton.php
class BluetoothDevicesManager {
  final List<ConnectedBluetoothDevice> connectedBluetoothDevices = [];
  static final BluetoothDevicesManager _cache =
      BluetoothDevicesManager._internal();

  // factory でシングルトンを実現
  factory BluetoothDevicesManager() {
    return _cache;
  }
  /*
  void saveDeviceSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> settingsStringList = [];
    await prefs.setStringList('deviceSettings', 777);
  }

  Future<List<String>> loadDviceSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('deviceSettings') ?? [];
  }
  */

  /// デバイスの新規登録
  /// 今の実装だとアプリを再起動すると再登録が必要.
  /// 将来的に SQLiteとかで保存→アプリ初期化時に読み出し... みたいにしたい
  void registerDevice(
    BluetoothDevice _device,
    String uuid,
    String? _name,
  ) {
    // すでに登録されていないか確認した方がいい

    connectedBluetoothDevices.add(ConnectedBluetoothDevice(
      _device,
      uuid,
      _name,
    ));
  }

  /*

  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value) {
      setState(() {
        _iosBlueState = value;
      });
    });
  }

  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) {
      setState(() {
        _blueLack = values;
      });
    });
  }

  */

  int getDevicesCount() {
    return connectedBluetoothDevices.length;
  }

  BluetoothDevicesManager._internal();
}

/// 一つのBluetoothデバイスを管理する
class ConnectedBluetoothDevice {
  late BluetoothDevice device;
  late String uuid;
  late String name;
  bool autoConnect = false;
  //final Queue<int> valueQueue = Queue();
  final List<int> valueQueue = [];
  static const int valueQueueLength = 100;
  bool isConnected = false;
  int threshold = 500;
  int operationId = 0; // コマンドの割り当て(未実装)
  var _services;

  ConnectedBluetoothDevice(
    BluetoothDevice device,
    String uuid,
    String? name,
  ) {
    this.device = device;
    this.uuid = uuid; // ほんとは良くない
    this.name = name ?? "Unnamed Device";

    () async {
      autoConnect = false;
      operationId = 0;
      threshold = 1000;

      this._services = await device.discoverServices();
      for (BluetoothService service in _services) {
        // ↑と↓で serviceのuuidとかで指定しないと良くないことが起きそう
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          characteristic.value.listen((value) {
            //this.valueQueue.addLast(lst2int(value));
            //this.valueQueue.removeFirst();
            this.valueQueue.add(lst2int(value));
            this.valueQueue.removeAt(0);
            print(
                "== Received: $value -> ${valueQueue[valueQueueLength - 1]} ==");
            //print(this.valueQueue);
          });
        }
      }
    }();

    for (int i = 0; i < valueQueueLength; i++) {
      this.valueQueue.add(0);
    }

    this.device.connect(timeout: Duration(seconds: 10));

    this.device.state.listen((newState) {
      ///newState is DeviceState type,include disconnected,disConnecting, connecting,connected, connectTimeout,initiativeDisConnected,destroyed
      print(newState.toString());
      if (newState == BluetoothDeviceState.connected) {
        print("connected!!!");

        /*
        //this.device.readDescriptorData(serviceUuid, characteristicUuid, descriptorUuid)
        this.device.deviceSignalResultStream.listen((result) {
          ///result type is DeviceSignalResult,is readonly.It have DeviceSignalType attributes,witch include characteristicsRead,characteristicsWrite,characteristicsNotify,descriptorRead,descriptorWrite,unKnown.
          ///In ios you will accept unKnown,because characteristicsRead is as same as characteristicsNotify for ios.So characteristicsRead or characteristicsNotify will return unKnown.
          print("--- deviceSignalResultStream ---");
          print(result.toString());
          print("-------------------");
        });
        */

        // とりあえず全部のserviceの全部のcharacteristicに対してnotyfyを設定した
        this.device.services.listen((services) {
          ///serviceItem type is BleService,is readonly.It include BleCharacteristic and BleDescriptor
          services.forEach(
            (service) {
              service.characteristics.forEach((characteristic) async {
                await characteristic.setNotifyValue(true);
              });
            },
          );

          // print("-----------");
          // print(serviceItem);
          // print(serviceItem.characteristics);
          // print(serviceItem.c);
        }, onError: (error) {
          print(error);
        }, onDone: () {
          print("done");
        });

        print("end state function");
      }
    }).onDone(() {
      ///if scan timeout or you stop scan,will into this
    });

    ///use this stream to listen discovery result
  }

  int lst2int(lst) {
    if (lst == null) {
      return 0;
    }

    num converted = 0;
    int l = lst.length;
    /*
    // 筋電位センサーの場合
    for (int i = 2; i < l; i++) {
      converted += (lst[l - i - 1] - 48) * pow(10, i - 2);
    }
    */
    for (int i = 0; i < l; i++) {
      converted += lst[i] * pow(256, i);
    }
    return converted.toInt();
  }

  List<charts.Series<BleData, int>> createGraph() {
    // グラフ描画用のデータ作成
    final List<BleData> ary = [];
    int l = valueQueue.length;
    for (int i = 0; i < l; i++) {
      ary.add(new BleData(i, valueQueue[i]));
    }

    return [
      charts.Series<BleData, int>(
        id: 'Log',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BleData value, _) => value.index,
        measureFn: (BleData value, _) => value.value,
        data: ary,
      )
    ];
  }
}

class BleData {
  final int index;
  final int value;

  BleData(this.index, this.value);
}
