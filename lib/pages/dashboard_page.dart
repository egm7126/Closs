import 'dart:async';
import 'package:c1/pages/setting_page.dart';
import 'package:c1/utils/app_colors.dart';
import 'package:c1/utils/app_components.dart';
import 'package:c1/utils/app_constants.dart';
import 'package:c1/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:korea_weather_api/korea_weather_api.dart';
import 'package:lottie/lottie.dart';
import '../utils/appTools.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({
    super.key,
  });

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with SingleTickerProviderStateMixin {
  //for weather
  String rainIndex = '';
  String skyForecast = '';

  Future<List<ItemSuperNct>> getSuperNctListJson({isLog = false}) async {
    appPrint('getSuperNctListJson >');
    final weather = Weather(
      serviceKey: weatherApiKey,
      pageNo: 1,
      numOfRows: 100,
      nx: coordLon,
      ny: coordLat,
    );
    final List<ItemSuperNct> items = [];
    final json =
        await SuperNctRepositoryImp(isLog: isLog).getItemListJSON(weather);
    json.map((e) => setState(() => items.add(e))).toList();

    return items;
  }
  Future<List<ItemSuperFct>> getSuperFctListJson({isLog = false}) async {
    appPrint('getSuperFctListJson >');
    final weather = Weather(
      serviceKey: weatherApiKey,
      pageNo: 1,
      numOfRows: 100,
      nx: coordLon,
      ny: coordLat,
    );
    final List<ItemSuperFct> items = [];
    final json =
        await SuperFctRepositoryImp(isLog: isLog).getItemListJSON(weather);
    json.map((e) => setState(() => items.add(e))).toList();

    return items;
  }

  void buildFromRecentData() {
    appPrint('readRecentData >');
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
    } catch (e) {
      appPrint('$e');
    }
    buildFromRecentData();
  }

  void loadWeatherData() async{
    try {
      recentFct = await loadFile('recentFctData', 'fct');
      recentNct = await loadFile('recentNctData', 'nct');
      DateTime now = DateTime.now();
      if (recentFct.time.add(const Duration(minutes: 30)).isBefore(now)) {
        //만약 최근 데이터 시간값의 30분을 더해도 현재보다 더 이전이라면
        //when too old data
        appPrint('call new weather data because recent data is too old');
        setWeatherData();
      } else {
        buildFromRecentData();
      }
    } catch (e) {
      appPrint('$e at loadWeatherData');
    }
  }

  Widget buildWeatherImage(String status) {
    appPrint('buildWeatherImage as $status');

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

    loadWeatherData();

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
      return AppPage(
        offInnerGap: true,
        child: SafeArea(
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
                              flex: 5,
                            ),
                            //title
                            const Expanded(
                              flex: 10,
                              child: Text(
                                '현재 가구 내부',
                                style: TextStyle(fontSize: fontMiddleBig),
                              ),
                            ),
                            //contents
                            Expanded(
                              flex: 50,
                              child: Row(
                                children: [
                                  const Spacer(
                                    flex: 10,
                                  ),
                                  //온도 습도
                                  Expanded(
                                    flex: 50,
                                    child: Column(
                                      children: [
                                        const Spacer(
                                          flex: 10,
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: _SettingButton(),
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
                                      child: Column(
                                        children: [
                                          const Spacer(flex: 10,),
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
                                              child: FanWidget(aniController: _fanAniController,),
                                            ),
                                          ),
                                          const Spacer(flex: 10,),
                                        ],
                                      )),
                                  const Spacer(
                                    flex: 10,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(
                              flex: 5,
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      appPrint(e.toString());
      return MaterialApp(
        debugShowCheckedModeBanner: false,
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

class FanWidget extends StatefulWidget {
  const FanWidget({
    super.key,
    required this.aniController,
  });

  final aniController;

  @override
  State<FanWidget> createState() => _FanWidgetState();
}

class _FanWidgetState extends State<FanWidget> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/moving icon/fan.json',
        controller: widget.aniController, onLoaded: (composition) {});
  }
}

class _SettingButton extends StatefulWidget {
  const _SettingButton({
    this.textStyle = const TextStyle(),
  });

  final TextStyle textStyle;

  @override
  State<_SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<_SettingButton> {

  @override
  void initState() {
    super.initState();
  }

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
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const SideHint(text: "온도"),
                          Expanded(
                            child: AppText(
                              '$innerTemp°C',
                              style: const TextStyle(color: appBlue),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const SideHint(text: '습도'),
                          Expanded(
                            child: AppText(
                              '$innerHum%',
                              style: const TextStyle(color: appBlue),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(flex: 10, child: ResultAnalyze()),
          ],
        ),
      ),
    );
  }
}

class ResultAnalyze extends StatefulWidget {
  const ResultAnalyze({
    super.key,
  });

  @override
  State<ResultAnalyze> createState() => _ResultAnalyzeState();
}

class _ResultAnalyzeState extends State<ResultAnalyze> {

  late Widget resultAnalyze;
  late Timer timer;

  void getGlobalAndAnalyze() async {
    //get global
    goodLowHum = await readDataFirestore('goodLowHum');
    goodLowTemp = await readDataFirestore('goodLowTemp');
    goodHighHum = await readDataFirestore('goodHighHum');
    goodHighTemp = await readDataFirestore('goodHighTemp');

    //analyze and display
    setState(() {
      if ((double.parse(goodLowHum) <= double.parse(innerHum)) &&
          (double.parse(goodHighHum) >= double.parse(innerHum))) {
        if ((double.parse(goodLowTemp) <= double.parse(innerTemp)) &&
            (double.parse(goodHighTemp) >= double.parse(innerTemp))) {
          resultAnalyze = Lottie.asset('assets/moving icon/good.json');
        } else {
          resultAnalyze = Lottie.asset('assets/moving icon/bad.json');
        }
      } else {
        resultAnalyze = Lottie.asset('assets/moving icon/bad.json');
      }
    });

  }

  @override
  void initState() {
    super.initState();
    resultAnalyze = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Lottie.asset(
          'assets/moving icon/indicatorGreenBars.json'),
    );
    timer = Timer.periodic(const Duration(seconds: 6), (_) {
      getGlobalAndAnalyze();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return resultAnalyze;
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

class ConditionEmoji extends StatelessWidget {
  const ConditionEmoji({
    super.key,
    required this.condition,
  });

  final String condition;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 250, child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: condition == 'good' ? Image.asset('assets/icon/good2.png') : condition == 'bad' ? Image.asset('assets/icon/bad.png') : Image.asset('assets/icon/sleeping.png'),
    ));
  }
}
