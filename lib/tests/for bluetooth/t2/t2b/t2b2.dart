import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _bluetoothClassicPlugin = BluetoothClassic();

  MyApp({super.key});

  Future<void> sendMessage(String message) async {
    await _bluetoothClassicPlugin.write(message);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Communication'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ...[
                for (var device in _devices)
                  TextButton(
                      onPressed: () async {
                        await _bluetoothClassicPlugin.connect(device.address,
                            "00001101-0000-1000-8000-00805f9b34fb");
                        setState(() {
                          _discoveredDevices = [];
                          _devices = [];
                        });
                      },
                      child: Text(device.name ?? device.address))
              ],
              ElevatedButton(
                onPressed: () async {
                  await sendMessage('how are you');
                },
                child: const Text('Send "how are you"'),
              ),
              StreamBuilder<List<int>>(
                stream: _bluetoothClassicPlugin.onDeviceDataReceived(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Received data: ${String.fromCharCodes(snapshot.data as Iterable<int>)}');
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
