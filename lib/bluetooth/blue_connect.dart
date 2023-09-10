import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:io';

//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path/path.dart';
import 'graph.dart';
import 'bluetooth_manager.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);
  final String title = "センサーの接続と設定";

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  // List<AndroidBluetoothLack> _blueLack = [];
  // IosBluetoothState _iosBlueState = IosBluetoothState.unKnown;
  List<ScanResult> _scanResultList = [];
  List<BluetoothDevice> _hideConnectedList = []; // いらない？
  bool _isScaning = false;
  late Timer _periodicScanTimer;
  late Timer test;

  @override
  void initState() {
    super.initState();
    _periodicScanTimer = Timer.periodic(const Duration(milliseconds: 2000),
        //     Platform.isAndroid ? androidGetBlueLack : iosGetBlueState
        (timer) {
      // 無くて良い気がする
    });
    /*
    test = Timer.periodic(const Duration(milliseconds: 500),
        //     Platform.isAndroid ? androidGetBlueLack : iosGetBlueState
        (timer) {
      print("timer length: " +
          BluetoothDevicesManager().getDevicesCount().toString());
      // 無くて良い気がする
    });
    */
    getHideConnectedDevice();
    //scanDevice();
  }

  /// 画面を離れる時に実行
  @override
  void dispose() {
    _periodicScanTimer.cancel();
    //test.cancel();
    super.dispose();
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

  /// OS側で既に接続されていてscan結果に表示されない機器を取得する
  void getHideConnectedDevice() {
    FlutterBluePlus.instance.connectedDevices.then((values) {
      setState(() {
        _hideConnectedList = values;
      });
    });
  }

  /// デバイスをスキャンして _scanResultList に格納する
  /// https://pub.dev/packages/flutter_blue_elves サンプルコードコピペしただけ
  void scanDevice() {
    if (_isScaning) {
      FlutterBluePlus.instance.stopScan();
      setState(() {
        _isScaning = false;
      });
    } else {
      setState(() {
        _isScaning = true;
      });
      FlutterBluePlus.instance
          .startScan(timeout: const Duration(seconds: 2))
          .then((value) {
        setState(() {
          _isScaning = false;
        });
        _scanResultList = value;
      });
    }
    /*
    getHideConnectedDevice();
    if ((Platform.isAndroid && _blueLack.isEmpty) ||
        (Platform.isIOS && _iosBlueState == IosBluetoothState.poweredOn)) {
      if (_isScaning) {
        FlutterBlueElves.instance.stopScan();
      } else {
        _scanResultList = [];
        setState(() {
          _isScaning = true;
        });
        FlutterBlueElves.instance.startScan(5000).listen((event) {
          setState(() {
            //_scanResultList.insert(0, event);
            _scanResultList.add(event);
          });
        }).onDone(() {
          setState(() {
            _isScaning = false;
          });
        });
      }
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildView(context),
    );
  }

  Widget _deviceListItemBuilder(BuildContext context, int index, String mode) {
    String currentDeviceName;
    if (mode == "connected") {
      BluetoothDevice currentDevice =
          BluetoothDevicesManager().connectedBluetoothDevices[index].device;
      currentDeviceName =
          BluetoothDevicesManager().connectedBluetoothDevices[index].name;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Row(
          children: [
            Text(
              currentDeviceName,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  print("遷移前 " +
                      index.toString() +
                      " / " +
                      BluetoothDevicesManager().getDevicesCount().toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraphPage(
                          connectedDeviceListIndex: index,
                        ),
                      ));
                },
                child: Text("設定")
                // Icon(Icons.build)
                ),
            SizedBox(
              width: 20,
            ), //表示する言葉は要検討
            ElevatedButton(
                onPressed: () {
                  print("before disconnect " +
                      BluetoothDevicesManager().getDevicesCount().toString());
                  currentDevice.disconnect().then(
                    (value) {
                      setState(() {
                        BluetoothDevicesManager()
                            .connectedBluetoothDevices
                            .removeAt(index);
                        print("after disconnect " +
                            BluetoothDevicesManager()
                                .getDevicesCount()
                                .toString());
                      });
                    },
                  );
                  scanDevice();
                },
                child: Text("接続解除")),
          ],
        ),
      );
    } else {
      /// mode == "scanned"
      ScanResult currentDevice = _scanResultList[index];
      currentDeviceName = currentDevice.device.name;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Row(
          children: [
            Text(
              currentDeviceName,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  /// デバイスに接続する
                  /// BluetoothDevicesManager() に追加し, _scanResultList から消す
                  BluetoothDevice toConnectDevice = currentDevice.device;
                  currentDevice.device
                      .connect(timeout: Duration(seconds: 10))
                      .then(
                    (value) {
                      setState(() {
                        BluetoothDevicesManager().registerDevice(
                          toConnectDevice,
                          currentDevice.device.id.toString(),
                          currentDevice.device.name,
                        );
                        _scanResultList.removeAt(index);
                        print(index.toString() +
                            " / " +
                            BluetoothDevicesManager()
                                .getDevicesCount()
                                .toString());
                      });
                    },
                  );
                },
                child: Text("接続")),
          ],
        ),
      );
    }
  }

  Widget _buildView(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              Text(
                "接続済みのセンサー",
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
            ],
          ),
        ),
        Flexible(
          child: ListView.separated(
            itemCount:
                (BluetoothDevicesManager().connectedBluetoothDevices.isNotEmpty
                    ? BluetoothDevicesManager().getDevicesCount()
                    : 0),
            itemBuilder: (BuildContext context, int index) {
              return _deviceListItemBuilder(context, index, "connected");
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.grey,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            children: [
              Text(
                "見つかったセンサー",
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              ElevatedButton(
                  child: Text(_isScaning ? "スキャン中..." : 'センサーを探す',
                      style: TextStyle(color: Colors.white)),
                  // scan中は押せないようにする
                  onPressed: _isScaning
                      ? null
                      : () {
                          scanDevice();
                        }),
            ],
          ),
        ),
        Flexible(
          child: ListView.separated(
            itemCount:
                (_scanResultList.isNotEmpty ? _scanResultList.length : 0),
            itemBuilder: (BuildContext context, int index) {
              return _deviceListItemBuilder(context, index, "scanned");
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.grey,
              );
            },
          ),
        ),
      ],
    );
  }
}
