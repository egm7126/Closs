import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothClassic _bluetoothClassic = BluetoothClassic();
  List<Device> _devices = [];
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  int _deviceStatus = Device.disconnected;
  Uint8List _data = Uint8List(0);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _bluetoothClassic.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    _bluetoothClassic.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
      });
    });

    _bluetoothClassic.onDeviceDataReceived().listen((event) {
      setState(() {
        _data = Uint8List.fromList([..._data, ...event]);
      });
    });
  }

  Future<void> _getDevices() async {
    var res = await _bluetoothClassic.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  Future<void> _scan() async {
    if (_scanning) {
      await _bluetoothClassic.stopScan();
      setState(() {
        _scanning = false;
      });
    } else {
      await _bluetoothClassic.startScan();
      _bluetoothClassic.onDeviceDiscovered().listen(
            (event) {
          setState(() {
            _discoveredDevices = [..._discoveredDevices, event];
          });
        },
      );
      setState(() {
        _scanning = true;
      });
    }
  }

  Future<void> _connectToDevice(String deviceAddress) async {
    await _bluetoothClassic.connect(deviceAddress, "00001101-0000-1000-8000-00805f9b34fb");
    setState(() {
      _discoveredDevices = [];
      _devices = [];
    });
  }

  Future<void> _disconnect() async {
    await _bluetoothClassic.disconnect();
  }

  Future<void> _sendData() async {
    await _bluetoothClassic.write("ping");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Communication'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Device status is $_deviceStatus"),
            TextButton(
              onPressed: () async {
                await _bluetoothClassic.initPermissions();
              },
              child: const Text("Check Permissions"),
            ),
            TextButton(
              onPressed: _getDevices,
              child: const Text("Get Paired Devices"),
            ),
            TextButton(
              onPressed: _deviceStatus == Device.connected ? _disconnect : null,
              child: const Text("disconnect"),
            ),
            TextButton(
              onPressed: _deviceStatus == Device.connected ? _sendData : null,
              child: const Text("send ping"),
            ),
            ..._devices.map((device) => TextButton(
                onPressed: () => _connectToDevice(device.address),
                child: Text(device.name ?? device.address)
            )).toList(),
            TextButton(
              onPressed: _scanning ? _stopScan : _startScan,
              child: Text(_scanning ? "Stop Scan" : "Start Scan"),
            ),
            ..._discoveredDevices.map((device) => Text(device.name ?? device.address)),
            Text("Received data: ${String.fromCharCodes(_data)}"),
          ],
        ),
      ),
    );
  }

  void _startScan() async {
    await _bluetoothClassic.startScan();
    setState(() {
      _scanning = true;
    });
  }

  void _stopScan() async {
    await _bluetoothClassic.stopScan();
    setState(() {
      _scanning = false;
    });
  }
}