import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'app_components.dart';
import 'dart:math' as Math;

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
      }else if(widget.displayType=='kor'){
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

// Future<Position> getCurrentGPS() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately.
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   return await Geolocator.getCurrentPosition();
// }
//
// Future<Position?> getPastGPS() async {
//   return await Geolocator.getLastKnownPosition();
// }

class GridGpsConvertor {
  static const double RE = 6371.00877; // 지구 반경(km)
  static const double GRID = 5.0; // 격자 간격(km)
  static const double SLAT1 = 30.0; // 투영 위도1(degree)
  static const double SLAT2 = 60.0; // 투영 위도2(degree)
  static const double OLON = 126.0; // 기준점 경도(degree)
  static const double OLAT = 38.0; // 기준점 위도(degree)
  static const double XO = 43; // 기준점 X좌표(GRID)
  static const double YO = 136; // 기1준점 Y좌표(GRID)

  static const double DEGRAD = Math.pi / 180.0;
  static const double RADDEG = 180.0 / Math.pi;

  static double get re => RE / GRID;

  static double get slat1 => SLAT1 * DEGRAD;

  static double get slat2 => SLAT2 * DEGRAD;

  static double get olon => OLON * DEGRAD;

  static double get olat => OLAT * DEGRAD;

  static double get snTmp =>
      Math.tan(Math.pi * 0.25 + slat2 * 0.5) /
          Math.tan(Math.pi * 0.25 + slat1 * 0.5);

  static double get sn =>
      Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(snTmp);

  static double get sfTmp => Math.tan(Math.pi * 0.25 + slat1 * 0.5);

  static double get sf => Math.pow(sfTmp, sn) * Math.cos(slat1) / sn;

  static double get roTmp => Math.tan(Math.pi * 0.25 + olat * 0.5);

  static double get ro => re * sf / Math.pow(roTmp, sn);

  static gridToGPS(int v1, int v2) {
    var rs = {};
    double theta;

    rs['x'] = v1;
    rs['y'] = v2;
    int xn = (v1 - XO).toInt();
    int yn = (ro - v2 + YO).toInt();
    var ra = Math.sqrt(xn * xn + yn * yn);
    if (sn < 0.0) ra = -ra;
    var alat = Math.pow((re * sf / ra), (1.0 / sn));
    alat = 2.0 * Math.atan(alat) - Math.pi * 0.5;

    if (xn.abs() <= 0.0) {
      theta = 0.0;
    } else {
      if (yn.abs() <= 0.0) {
        theta = Math.pi * 0.5;
        if (xn < 0.0) theta = -theta;
      } else
        theta = Math.atan2(xn, yn);
    }
    var alon = theta / sn + olon;
    rs['lat'] = alat * RADDEG;
    rs['lng'] = alon * RADDEG;

    return rs;
  }

  static gpsToGRID(double v1, double v2) {
    var rs = {};
    double theta;

    rs['lat'] = v1;
    rs['lng'] = v2;
    var ra = Math.tan(Math.pi * 0.25 + (v1) * DEGRAD * 0.5);
    ra = re * sf / Math.pow(ra, sn);
    theta = v2 * DEGRAD - olon;
    if (theta > Math.pi) theta -= 2.0 * Math.pi;
    if (theta < -Math.pi) theta += 2.0 * Math.pi;
    theta *= sn;
    rs['x'] = (ra * Math.sin(theta) + XO + 0.5).floor();
    rs['y'] = (ro - ra * Math.cos(theta) + YO + 0.5).floor();

    return rs;
  }
}

rainCodeToString(int code) {
  switch (code) {
    case 0:
      return 'sunny';
    case 1:
      return 'rainy';
    case 2:
      return 'snow';
    case 3:
      return 'snow';
    case 5:
      return 'rainy';
    case 6:
      return 'snow';
    case 7:
      return 'snow';
  }
}

skyCodeToString(int code) {
  switch (code) {
    case 1:
      return 'sunny';
    case 3:
      return 'cloudy';
    case 4:
      return 'cloudy';
  }
}

// class GeoGridText extends StatefulWidget {
//   GeoGridText({
//     super.key,
//   });
//
//   Position? position;
//   var gridCoords;
//   bool isFirst = true;
//
//   @override
//   State<GeoGridText> createState() => _GeoGridTextState();
// }

// class _GeoGridTextState extends State<GeoGridText> {
//
//   void getKnownGEO() async{
//     appToast(msg: 'test 1 이전 위치 정보를 이용합니다.');
//
//     try {
//       final fetchedPosition = await getPastGPS();
//       setState(() {
//         widget.position = fetchedPosition;
//         appToast(msg: 'test 1 위치 정보를 새로고침했습니다.');
//       });
//     } catch (e) {
//       appToast(msg: 'test 1 위치 정보를 가져오는 동안 오류가 발생했습니다.');
//     }
//     calculateGrid();
//   }
//
//   //calculate geo coordinates->grid
//   void calculateGrid() {
//     widget.gridCoords = GridGpsConvertor.gpsToGRID(
//       widget.position != null ? widget.position!.latitude : 0,
//       widget.position != null ? widget.position!.longitude : 0,
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if(widget.isFirst){
//       getKnownGEO();
//       widget.isFirst = false;
//     }
//     return Text(
//         widget.gridCoords != null ?
//         '${widget.gridCoords['x']}, ${widget.gridCoords['y']}' : 'not yet'
//     );
//   }
// }

// class GeoCrdText extends StatefulWidget {
//   GeoCrdText({
//     super.key,
//   });
//
//   Position? position;
//   bool isFirst = true;
//
//   @override
//   State<GeoCrdText> createState() => _GeoCrdTextState();
//
//   Future<String> getLocationString() async{
//     appToast(msg: 'test 1 이전 위치 정보를 이용합니다.');
//
//     try {
//       final fetchedPosition = await getPastGPS();
//
//         position = fetchedPosition;
//         appToast(msg: 'test 1 위치 정보를 새로고침했습니다.');
//
//     } catch (e) {
//       appToast(msg: 'test 1 위치 정보를 가져오는 동안 오류가 발생했습니다.');
//     }
//
//     if (position !=null){
//       return '${position!.latitude}, ${position!.longitude}';
//     } else {
//       return '1';
//     }
//   }
// }
//
// class _GeoCrdTextState extends State<GeoCrdText> {
//
//   void getKnownGEO() async{
//     appToast(msg: 'test 1 이전 위치 정보를 이용합니다.');
//
//     try {
//       final fetchedPosition = await getPastGPS();
//       setState(() {
//         widget.position = fetchedPosition;
//         appToast(msg: 'test 1 위치 정보를 새로고침했습니다.');
//       });
//     } catch (e) {
//       appToast(msg: 'test 1 위치 정보를 가져오는 동안 오류가 발생했습니다.');
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if(widget.isFirst){
//       getKnownGEO();
//       widget.isFirst = false;
//     }
//     return Text(
//         widget.position != null ?
//         '${widget.position!.latitude}, ${widget.position!.longitude}' : 'not yet'
//     );
//   }
// }