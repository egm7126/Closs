import 'package:c1/utils/app_components.dart';
import 'package:korea_weather_api/korea_weather_api.dart';

double coordLon = 126.5765034; //경도
double coordLat = 36.4119319; //위도

String innerHum = '';
String innerTemp = '';
String outerHum = '';
String outerTemp = '';
String fan = '';

String goodLowHum='';
String goodLowTemp='';
String goodHighHum='';
String goodHighTemp='';
String actTemp = '';
String actHum = '';
String stopTemp = '';
String stopHum = '';

bool isWeatherUpdated = false;

//weather relations
late Future<List<ItemSuperNct>> superNctItems;
late Future<List<ItemSuperFct>> superFctItems;
late SuperNctListWithTime recentNct;
late SuperFctListWithTime recentFct;

class SuperNctListWithTime{
  List<ItemSuperNct> itemList;
  DateTime time;

  SuperNctListWithTime(this.itemList, this.time);

  Map<String, dynamic> toJson() => {
    'itemList': itemList.map((item) => item.toJson()).toList(),
    'time': time.toIso8601String(),
  };

  factory SuperNctListWithTime.fromJson(Map<String, dynamic> json) {
    List<ItemSuperNct> itemList = (json['itemList'] as List<dynamic>)
        .map((itemJson) => ItemSuperNct.fromJson(itemJson))
        .toList();
    DateTime time = DateTime.parse(json['time']);
    return SuperNctListWithTime(itemList, time);
  }
}

class SuperFctListWithTime{
  List<ItemSuperFct> itemList;
  DateTime time;

  SuperFctListWithTime(this.itemList, this.time);

  Map<String, dynamic> toJson() => {
    'itemList': itemList.map((item) => item.toJson()).toList(),
    'time': time.toIso8601String(),
  };

  factory SuperFctListWithTime.fromJson(Map<String, dynamic> json) {
    List<ItemSuperFct> itemList = (json['itemList'] as List<dynamic>)
        .map((itemJson) => ItemSuperFct.fromJson(itemJson))
        .toList();
    DateTime time = DateTime.parse(json['time']);
    return SuperFctListWithTime(itemList, time);
  }
}