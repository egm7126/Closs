import 'dart:async';
import 'package:flutter/material.dart';
import 'app_components.dart';
import 'app_constants.dart';

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

class ClockText extends StatefulWidget {
  const ClockText({
    Key? key,
    this.frontString = '',
    this.y = false,
    this.mth = false,
    this.d = false,
    this.h = false,
    this.min = false,
    this.s = false,
    this.style = const TextStyle(),
    this.displayType = ':',
    this.makePM = true,
  }) : super(key: key);

  final String frontString;

  final bool y;
  final bool mth;
  final bool d;
  final bool h;
  final bool min;
  final bool s;

  final TextStyle style;

  final String displayType;

  final bool makePM;

  @override
  _ClockTextState createState() => _ClockTextState();
}

class _ClockTextState extends State<ClockText> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
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
    String returnString='';
    int hour=0;
    if(widget.y){
      returnString = '$returnString${_currentTime.year}년';
    }
    if(widget.mth){
      if(returnString!=''){
        returnString = '$returnString ';
      }
      returnString = '$returnString${_currentTime.month}월';
    }
    if(widget.d){
      if(returnString!=''){
        returnString = '$returnString ';//띄어쓰기
      }
      returnString = '$returnString${_currentTime.day}일';
    }
    if(widget.h){
      hour = _currentTime.hour;
      if(widget.makePM){
        if(_currentTime.hour>=13){
          hour = _currentTime.hour-12;
        }
      }

      if(returnString!=''){
        returnString = '$returnString ';//띄어쓰기
      }
      if(widget.displayType==':'){
        returnString = '$returnString$hour :';
      }else{
        returnString = '$returnString$hour시';
      }

    }
    if(widget.min){
      if(returnString!=''){
        returnString = '$returnString ';//띄어쓰기
      }
      if(widget.displayType==':'){
        returnString = ' $returnString${_currentTime.minute}';
      }else{
        returnString = '$returnString${_currentTime.minute}분';
      }

    }
    if(widget.s){
      if(returnString!=''){
        returnString = '$returnString ';//띄어쓰기
      }
      returnString = '$returnString${_currentTime.second}초';
    }
    return Text(widget.frontString+returnString, style: widget.style,);
  }
}