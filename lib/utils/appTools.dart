import 'dart:async';
import 'package:flutter/material.dart';
import 'appComponents.dart';
import 'appConstansts.dart';

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: child,
    );
  }
}

class SizeFixer extends StatelessWidget {
  const SizeFixer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), child: child);
  }
}

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '현재 시각: ${_currentTime.hour}:${_currentTime.minute}:${_currentTime.second}',
      style: TextStyle(
        fontSize: fontMiddle,
      ),
    );
  }
}