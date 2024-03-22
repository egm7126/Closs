import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Address Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<String>(
                future: BluetoothClassic.address,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Bluetooth Address: ${snapshot.data}');
                  } else {
                    return const CircularProgressIndicator();
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
