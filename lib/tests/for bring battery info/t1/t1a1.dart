import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Battery Info',
      home: BluetoothBatteryScreen(),
    );
  }
}

class BluetoothBatteryScreen extends StatefulWidget {
  const BluetoothBatteryScreen({super.key});

  @override
  _BluetoothBatteryScreenState createState() => _BluetoothBatteryScreenState();
}

class _BluetoothBatteryScreenState extends State<BluetoothBatteryScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothDevice? _connectedDevice;
  String _batteryInfo = 'No battery info';

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    try {
      await bluetooth.requestEnable();
    } catch (e) {
      print(e);
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await bluetooth.connect(device);
      setState(() {
        _connectedDevice = device;
      });
      _requestBatteryInfo();
    } catch (e) {
      print(e);
    }
  }

  void _requestBatteryInfo() async {
    try {
      bluetooth.write("batteryInfoRequest"); // 배터리 정보 요청
      bluetooth.onRead()?.listen((data) {
        setState(() {
          _batteryInfo = data as String;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Battery Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _connectedDevice != null
                  ? 'Connected to: ${_connectedDevice!.name}'
                  : 'Not connected',
            ),
            const SizedBox(height: 20),
            Text('Battery Info: $_batteryInfo'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                bluetooth.startDiscovery().listen((device) {
                  // 디바이스 목록 보여주고 선택할 수 있는 UI 로직
                  // 선택한 디바이스로 _connectToDevice 함수 호출
                });
              },
              child: const Text('Search for devices'),
            ),
          ],
        ),
      ),
    );
  }
}
