import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Info',
      home: BatteryInfoScreen(),
    );
  }
}

class BatteryInfoScreen extends StatefulWidget {
  @override
  _BatteryInfoScreenState createState() => _BatteryInfoScreenState();
}

class _BatteryInfoScreenState extends State<BatteryInfoScreen> {
  Battery _battery = Battery();
  BatteryState _batteryState = BatteryState.unknown;
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
  }

  Future<void> _getBatteryInfo() async {
    final batteryState = await _battery.batteryState;
    final batteryLevel = await _battery.batteryLevel;

    setState(() {
      _batteryState = batteryState;
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Battery Level: $_batteryLevel%',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Battery State: $_batteryState',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}