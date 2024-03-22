import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  final String targetDeviceName = "ClossControlBox";
  final String targetServiceUUID = "00001101-0000-1000-8000-00805f9b34fb";
  final String targetCharacteristicUUID = "00001101-0000-1000-8000-00805f9b34fb";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectToDevice();
  }

  Future<void> connectToDevice() async {
    List<ScanResult> scanResults = (await flutterBlue.scan(timeout: Duration(seconds: 4))) as List<ScanResult>;
    for (ScanResult result in scanResults) {
      if (result.device.name == targetDeviceName) {
        targetDevice = result.device;
        break;
      }
    }
    if (targetDevice != null) {
      await targetDevice!.connect();
      List<BluetoothService> services = await targetDevice!.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString() == targetServiceUUID) {
          targetCharacteristic = service.characteristics
              .firstWhere((characteristic) => characteristic.uuid.toString() == targetCharacteristicUUID);
          break;
        }
      }
    }
  }

  Future<void> sendMessage(String message) async {
    if (targetCharacteristic != null) {
      List<int> bytes = message.codeUnits;
      await targetCharacteristic!.write(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Enter a message'),
            ),
            ElevatedButton(
              onPressed: () {
                String message = textController.text;
                sendMessage(message);
                textController.clear();
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
