import 'package:c1/utils/app_components.dart';
import 'package:korea_weather_api/korea_weather_api.dart';

double CoordLon = 126.5765034; //경도
double CoordLat = 36.4119319; //위도

String innerHum = '';
String innerTemp = '';
String outerHum = '';
String outerTemp = '';
String fan = '';

String settingHum='';
String settingTemp='';

bool isWeatherUpdated = false;

//weather relations
late Future<List<ItemSuperNct>> superNctItems;
late Future<List<ItemSuperFct>> superFctItems;
late RecentSuperNctData recentNct;
late RecentSuperFctData recentFct;

class RecentSuperNctData{
  List<ItemSuperNct> itemList;
  DateTime time;

  RecentSuperNctData(this.itemList, this.time);

  Map<String, dynamic> toJson() => {
    'itemList': itemList.map((item) => item.toJson()).toList(),
    'time': time.toIso8601String(),
  };

  factory RecentSuperNctData.fromJson(Map<String, dynamic> json) {
    List<ItemSuperNct> itemList = (json['itemList'] as List<dynamic>)
        .map((itemJson) => ItemSuperNct.fromJson(itemJson))
        .toList();
    DateTime time = DateTime.parse(json['time']);
    return RecentSuperNctData(itemList, time);
  }
}

class RecentSuperFctData{
  List<ItemSuperFct> itemList;
  DateTime time;

  RecentSuperFctData(this.itemList, this.time);

  Map<String, dynamic> toJson() => {
    'itemList': itemList.map((item) => item.toJson()).toList(),
    'time': time.toIso8601String(),
  };

  factory RecentSuperFctData.fromJson(Map<String, dynamic> json) {
    List<ItemSuperFct> itemList = (json['itemList'] as List<dynamic>)
        .map((itemJson) => ItemSuperFct.fromJson(itemJson))
        .toList();
    DateTime time = DateTime.parse(json['time']);
    return RecentSuperFctData(itemList, time);
  }
}