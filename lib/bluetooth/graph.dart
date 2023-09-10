import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';
import 'bluetooth_manager.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';

class GraphPage extends StatefulWidget {
  late int connectedDeviceListIndex;
  GraphPage({Key? key, required int this.connectedDeviceListIndex})
      : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  bool isAutoConnect = false;
  int operationId = 0;
  int threshold = 400;
  final TextEditingController _thresholdController = TextEditingController();

  _GraphPageState() {
    final periodicTimer =
        new Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      //　別の画面に移動した時に画面更新をしないように
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.connectedDeviceListIndex.toString() +
        " / " +
        BluetoothDevicesManager().getDevicesCount().toString());

    isAutoConnect = BluetoothDevicesManager()
        .connectedBluetoothDevices[widget.connectedDeviceListIndex]
        .autoConnect;
    operationId = BluetoothDevicesManager()
        .connectedBluetoothDevices[widget.connectedDeviceListIndex]
        .operationId;
    threshold = BluetoothDevicesManager()
        .connectedBluetoothDevices[widget.connectedDeviceListIndex]
        .threshold;

    setState(() {
      _thresholdController.text = threshold.toString();
    });
  }

  void read() {
    /*
    BluetoothDevicesManager()
        .connectedBluetoothDevices[widget.connectedDeviceListIndex]
        .device
        .serviceDiscoveryStream
        .listen((event) {
      print("bbb");
      event.characteristics.forEach((characteristic) {
        print(characteristic);
        if (characteristic.properties.contains(CharacteristicProperties.read)) {
          print(BluetoothDevicesManager()
              .connectedBluetoothDevices[widget.connectedDeviceListIndex]
              .device
              .readData(event.serviceUuid, characteristic.uuid));
        }
      });
    });*/
  }

  /*
  void setNotify() {
    print("aaa");
    BluetoothDevicesManager()
        .connectedBluetoothDevices[widget.connectedDeviceListIndex]
        .device
        .deviceSignalResultStream
        .listen(((event) {
      print(event.type);
      if (event.type == DeviceSignalType.characteristicsNotify) {
        print(event.data);
      }
    }));
    print("¥¥¥");
    BluetoothDevicesManager()
        .connectedBluetoothDevices[widget.connectedDeviceListIndex]
        .device
        .serviceDiscoveryStream
        .listen((event) {
      print("bbb");
      event.characteristics.forEach((characteristic) {
        print(characteristic);
        if (characteristic.properties
                .contains(CharacteristicProperties.notify) ||
            characteristic.properties
                .contains(CharacteristicProperties.indicate)) {
          BluetoothDevicesManager()
              .connectedBluetoothDevices[widget.connectedDeviceListIndex]
              .device
              .setNotify(event.serviceUuid, characteristic.uuid, true)
              .then((value) {
            if (value) {
              print(value.toString());
            }
          });
        }
      });
    });
  }
  */

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(BluetoothDevicesManager()
              .connectedBluetoothDevices[widget.connectedDeviceListIndex]
              .name),
        ),
        body: Scrollbar(
          child: GestureDetector(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                child: Column(children: [
                  Container(
                      height: 400,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: charts.LineChart(
                            BluetoothDevicesManager()
                                .connectedBluetoothDevices[widget
                                    .connectedDeviceListIndex] // 要修正 暫定的に０番目にしてある
                                .createGraph(),
                            animate: false,
                            domainAxis: charts.NumericAxisSpec(
                              renderSpec: charts.NoneRenderSpec(),
                            ),
                            behaviors: [
                              charts.RangeAnnotation([
                                // 線を引く
                                // https://google.github.io/charts/flutter/example/line_charts/range_annotation.html
                                charts.RangeAnnotationSegment(255, 256,
                                    charts.RangeAnnotationAxisType.measure,
                                    startLabel: "max",
                                    color: charts
                                        .MaterialPalette.red.shadeDefault),
                                charts.RangeAnnotationSegment(
                                  255,
                                  256,
                                  charts.RangeAnnotationAxisType.measure,
                                  startLabel: "threshold",
                                  color:
                                      charts.MaterialPalette.red.shadeDefault,
                                ),
                              ])
                            ],
                          ))
                        ],
                      )),
                  Row(
                    children: [
                      TextButton(onPressed: read, child: Text("Read")),
                      // TextButton(onPressed: setNotify, child: Text("setNotify"))
                    ],
                  )
                ]),
              ),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      );
}
