import 'package:flutter/material.dart';

import 'MainPage.dart';

//https://github.com/edufolly/flutter_bluetooth_serial/blob/master/example/README.md

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
  }
}
