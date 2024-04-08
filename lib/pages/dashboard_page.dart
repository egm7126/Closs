import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:c1/pages/setting_page.dart';
import 'package:c1/utils/app_colors.dart';
import 'package:c1/utils/app_components.dart';
import 'package:c1/utils/app_constants.dart';
import 'package:c1/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:korea_weather_api/korea_weather_api.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/appTools.dart';
// import '../utils/bt_relations/ChatPage.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({
    super.key,
  });

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with SingleTickerProviderStateMixin {
  //for weahter
  String rainIndex = '';
  String skyForecast = '';

  Future<List<ItemSuperNct>> getSuperNctListJson({isLog = false}) async {
    final weather = Weather(
      serviceKey: weatherApiKey,
      pageNo: 1,
      numOfRows: 100,
      nx: CoordLon,
      ny: CoordLat,
    );
    final List<ItemSuperNct> items = [];
    final json =
        await SuperNctRepositoryImp(isLog: isLog).getItemListJSON(weather);
    json.map((e) => setState(() => items.add(e))).toList();

    return items;
  }

  Future<List<ItemSuperFct>> getSuperFctListJson({isLog = false}) async {
    final weather = Weather(
      serviceKey: weatherApiKey,
      pageNo: 1,
      numOfRows: 100,
      nx: CoordLon,
      ny: CoordLat,
    );
    final List<ItemSuperFct> items = [];
    final json =
        await SuperFctRepositoryImp(isLog: isLog).getItemListJSON(weather);
    json.map((e) => setState(() => items.add(e))).toList();

    return items;
  }

  void putFct2Vars() {
    superFctItems.then((items) {
      for (ItemSuperFct item in items) {
        setState(() {
          if (item.category == 'SKY') {
            skyForecast = item.fcstValue!;
          }
        });
      }
    });
  }

  void putNct2Vars() {
    superNctItems.then((items) {
      for (ItemSuperNct item in items) {
        setState(() {
          if (item.category == 'REH') {
            outerHum = item.obsrValue!;
          } else if (item.category == 'T1H') {
            outerTemp = item.obsrValue!;
          } else if (item.category == 'PTY') {
            rainIndex = rainCodeToString(int.parse(item.obsrValue ?? '0'));
          }
        });
      }
    });
  }

  void readRecentData() {
    appPrint('readRecentData >');
    if (recentFct != null) {
      recentFct = loadFile('recentFctData');
      recentNct = loadFile('recentNctData');
    }
    for (ItemSuperFct item in recentFct.itemList) {
      setState(() {
        if (item.category == 'SKY') {
          skyForecast = item.fcstValue!;
        }
      });
    }
    for (ItemSuperNct item in recentNct.itemList) {
      setState(() {
        if (item.category == 'REH') {
          outerHum = item.obsrValue!;
        } else if (item.category == 'T1H') {
          outerTemp = item.obsrValue!;
        } else if (item.category == 'PTY') {
          rainIndex = rainCodeToString(int.parse(item.obsrValue ?? '0'));
        }
      });
    }
  }

  void setWeatherData() async {
    appPrint('setWeatherData >');
    try {
      superFctItems = getSuperFctListJson();
      superNctItems = getSuperNctListJson();
      List<ItemSuperFct> gotFct = await superFctItems;
      List<ItemSuperNct> gotNct = await superNctItems;
      recentFct = RecentSuperFctData(gotFct, DateTime.now());
      recentNct = RecentSuperNctData(gotNct, DateTime.now());
      saveFile('recentFctData', recentFct);
      saveFile('recentNctData', recentNct);
      putFct2Vars();
      putNct2Vars();
    } catch (e) {
      readRecentData();
    }
  }

  //for innerCondition
  String innerCondition = '';

  //for control
  late AnimationController _fanAniController; //for fan animation
  late StreamSubscription<DocumentSnapshot>
      _subscriptionFirebase; //for read firebase
  bool showAppIndicator = true; //for app loading
  void playFan() {
    _fanAniController.repeat(
      min: 17 / 60, // 반복을 시작할 위치 (0.0은 처음부터 시작)
      max: 34 / 60, // 반복을 종료할 위치 (1.0은 애니메이션의 끝)
      period: const Duration(milliseconds: 500), // 반복할 구간의 시간 설정
    );
  }

  void pauseFan() {
    _fanAniController.stop(); // 현재 프레임에서 멈춥니다.
  }

  @override
  void initState() {
    super.initState();
    // Timer 설정: 30초 후에 AppIndicator를 숨김
    Timer(const Duration(seconds: 20), () {
      setState(() {
        showAppIndicator = false;
      });
    });

    try {
      recentFct = loadFile('recentFctData');
      recentNct = loadFile('recentNctData');
      DateTime now = DateTime.now();
      if (recentFct.time.add(const Duration(minutes: 30)).isBefore(now)) {
        //만약 최근 데이터 시간값의 30분을 더해도 현재보다 더 이전이라면
        //when too old data
        setWeatherData();
      } else {
        readRecentData();
      }
    } catch (e) {
      setWeatherData();
    }

    //for control
    _fanAniController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _subscriptionFirebase = FirebaseFirestore.instance
        .collection(productName)
        .doc(productSerial)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          // 'temp' 필드가 변경되었을 때 UI를 업데이트합니다.
          innerTemp = snapshot.data()?['temp'].toString() ?? 'No Data';
          innerHum = snapshot.data()?['hum'].toString() ?? 'No Data';
          fan = snapshot.data()?['fan'].toString() ?? 'No Data';
        });
      }
    });
    if (fan == 'on') {
      playFan();
    } else {
      pauseFan();
    }
  }

  @override
  void dispose() {
    _fanAniController.dispose();
    _subscriptionFirebase.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
            fontFamily: 'AppFont',
            textTheme: const TextTheme(
              bodySmall: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  //upper part
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        //weather
                        Expanded(
                          flex: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //weather sign
                              Expanded(
                                flex: 10,
                                child: buildWeatherImage(
                                    skyCodeToString(int.parse(skyForecast))),
                              ),

                              //presentation weather information
                              Expanded(
                                flex: 10,
                                child: Column(
                                  children: [
                                    const Spacer(
                                      flex: 20,
                                    ),
                                    Expanded(
                                      flex: 30,
                                      child: AppContainer(
                                        border: borderMiddle,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //year, month, date
                                            Expanded(
                                              flex: 10,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0),
                                                child: ClockText(
                                                  y: true,
                                                  mth: true,
                                                  d: true,
                                                ),
                                              ),
                                            ),

                                            //hour, minutes
                                            Expanded(
                                              flex: 20,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                                child: ClockText(
                                                  h: true,
                                                  min: true,
                                                  style: TextStyle(
                                                    fontFamily: 'PrettyAppFont',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  displayType: ':',
                                                ),
                                              ),
                                            ),

                                            // presentation weather temp, hum
                                            Expanded(
                                              flex: 10,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: AppText(
                                                  '$outerTemp°C  $outerHum%',
                                                  style: const TextStyle(
                                                    color: appPoint,
                                                  ),
                                                  minFontSize: 30,
                                                ),
                                              ),
                                            ),
                                            //Text(geoCrdText.getLocationString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: [
                        //       OtherCityCard(
                        //         cityCountry: '대한민국',
                        //         cityName: '부산',
                        //         hum: '60%',
                        //         temp: '25도',
                        //       ),
                        //       OtherCityCard(
                        //         cityCountry: '대한민국',
                        //         cityName: '서울',
                        //         hum: '40%',
                        //         temp: '18도',
                        //       ),
                        //       OtherCityCard(
                        //         cityCountry: '미국',
                        //         cityName: '뉴욕',
                        //         hum: '30%',
                        //         temp: '24도',
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  //downer part
                  Expanded(
                    flex: 15,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: appBackGrey,
                          ),
                          child: Column(
                            children: [
                              const Spacer(
                                flex: 10,
                              ),
                              const Expanded(
                                flex: 10,
                                child: Text(
                                  '현재 가구 내부',
                                  style: TextStyle(fontSize: fontMiddleBig),
                                ),
                              ),
                              //온도 습도
                              Expanded(
                                flex: 15,
                                child: Row(
                                  children: [
                                    const Spacer(
                                      flex: 10,
                                    ),
                                    Expanded(
                                      flex: 15,
                                      child: _SettingButton(
                                        index: '온도 습도',
                                        value: '$innerTemp°C $innerHum%',
                                        textStyle: TextStyle(color: appBlue),
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(
                                flex: 10,
                              ),
                              //fan
                              Expanded(
                                  flex: 30,
                                  child: Row(
                                    children: [
                                      const Spacer(
                                        flex: 10,
                                      ),
                                      //fan button
                                      Expanded(
                                        flex: 10,
                                        child: AppButton(
                                          onPressed: () {
                                            if (fan == 'off') {
                                              updateDataFirestore('fan', 'on');
                                              playFan();
                                            } else if (fan == 'on') {
                                              updateDataFirestore('fan', 'off');
                                              pauseFan();
                                            }
                                          },
                                          color: Colors.transparent,
                                          child: Lottie.asset(
                                              'assets/moving icon/fan.json',
                                              controller: _fanAniController,
                                              onLoaded: (composition) {}),
                                        ),
                                      ),

                                      const Spacer(
                                        flex: 10,
                                      ),
                                    ],
                                  )),
                              const Spacer(
                                flex: 10,
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      appPrint(e.toString());
      return MaterialApp(
        home: Scaffold(
          body: Center(
              child: showAppIndicator
                  ? const SizedBox(
                      height: 300, width: 300, child: AppIndicator())
                  : const AppContainer(
                      border: borderMiddle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AppText('날씨 정보를 불러올 수 없습니다. '),
                      ))),
        ),
      );
    }
  }
}

buildWeatherImage(String status) {
  appPrint(status);

  switch (status) {
    case 'sunny':
      return Image.asset('assets/icon/sunny.png');
    case 'cloudy':
      return Image.asset('assets/icon/cloudy.png');
    case 'rainy':
      return Image.asset('assets/icon/rainy.png');
    case 'lightning':
      return Image.asset('assets/icon/lightning.png');
    default:
      return Image.asset('assets/icon/sunny.png');
  }
}

class _SettingButton extends StatelessWidget {
  const _SettingButton({
    required this.index,
    required this.value,
    this.textStyle = const TextStyle(),
  });

  final String index;
  final String value;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
      },
      child: AppContainer(
        border: borderMiddle,
        child: Row(
          children: [
            Expanded(
              flex: 14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    index,
                    //style: textStyle,
                    minFontSize: fontMiddleBig,
                  ),
                  AppText(
                    value,
                    style: textStyle,
                    minFontSize: fontMiddle,
                  ),
                ],
              ),
            ),
            Expanded(flex: 10, child: ResultAnaylze()),
          ],
        ),
      ),
    );
  }
}

class OtherCityCard extends StatelessWidget {
  const OtherCityCard({
    super.key,
    required this.cityName,
    required this.cityCountry,
    required this.hum,
    required this.temp,
  });

  final String cityName;
  final String cityCountry;
  final String hum;
  final String temp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 100,
        width: 130,
        child: AppContainer(
            border: borderSmall,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        cityName,
                        style: const TextStyle(fontSize: fontMiddle),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        cityCountry,
                        style: const TextStyle(
                            fontSize: fontLittle, color: fontGrey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "온도",
                              style: TextStyle(
                                  fontSize: fontLittle, color: fontGrey),
                            ),
                            Text(
                              temp,
                              style: const TextStyle(fontSize: fontSmall),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "습도",
                              style: TextStyle(
                                  fontSize: fontLittle, color: fontGrey),
                            ),
                            Text(
                              hum,
                              style: const TextStyle(fontSize: fontSmall),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

Widget ResultAnaylze() {
  Widget returnWidget =
      Lottie.asset('assets/moving icon/indicatorGreenBars.json');
  if (double.parse(innerHum) <= 50) {
    //returnWidget = Lottie.asset('assets/moving icon/good.json');
    returnWidget = SizedBox(height: 250, child: AppText("😊"));
  } else {
    returnWidget = Lottie.asset('assets/moving icon/bad.json');
  }
  return returnWidget;
}
