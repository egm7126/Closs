import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:c1/pages/setting_page.dart';
import 'package:c1/utils/app_colors.dart';
import 'package:c1/utils/app_components.dart';
import 'package:c1/utils/app_constants.dart';
import 'package:c1/utils/global_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:korea_weather_api/korea_weather_api.dart';
import 'package:lottie/lottie.dart';
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

  ///weather relations
  late Future<List<ItemSuperNct>> superNctItems; //날씨 데이터 행렬을 받을 녀석
  late Future<List<ItemSuperFct>> superFctItems;

  ///funiture relations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String rainIndex = '';
  String skyForecast = '';

  String innerCondition = '';

  late AnimationController _fanAniController;

  late StreamSubscription<DocumentSnapshot> _subscriptionFirebase;

  @override
  void initState() {
    super.initState();

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
          temp = snapshot.data()?['temp'].toString() ?? 'No Data';
          hum = snapshot.data()?['hum'].toString() ?? 'No Data';
          fan = snapshot.data()?['fan'].toString() ?? 'No Data';
        });
      }
    });

    ///weather relations
    //카테고리별 날씨데이터 행렬을 받기
    superNctItems = getSuperNctListJson();
    superFctItems = getSuperFctListJson();

    // getItemNctListJson
    superNctItems.then((items) {
      for (ItemSuperNct item in items) {
        setState(() {
          if (item.category == 'REH') {
            hum = item.obsrValue!;
          } else if (item.category == 'T1H') {
            temp = item.obsrValue!;
          } else if (item.category == 'PTY') {
            rainIndex = rainCodeToString(int.parse(item.obsrValue ?? '0'));
          }
        });
      }
    });

    // getItemFctListJson
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

  @override
  void dispose() {
    _fanAniController.dispose();
    _subscriptionFirebase.cancel();
    super.dispose();
  }

  //return item list(여러 category의 data를 돌려줌)
  Future<List<ItemSuperNct>> getSuperNctListJson({isLog = false}) async {
    final weather = Weather(
      serviceKey: weatherApiKey,
      pageNo: 1,
      numOfRows: 100,
      nx: nx,
      ny: ny,
    );
    final List<ItemSuperNct> items = [];
    final json =
        await SuperNctRepositoryImp(isLog: isLog).getItemListJSON(weather);

    json.map((e) => setState(() => items.add(e))).toList();

    return items;
  } //#todo 너무 오랫동안 안불러와질때 대처

  Future<List<ItemSuperFct>> getSuperFctListJson({isLog = false}) async {
    final weather = Weather(
      serviceKey: weatherApiKey,
      pageNo: 1,
      numOfRows: 100,
      nx: nx,
      ny: ny,
    );

    final List<ItemSuperFct> items = [];

    final json =
        await SuperFctRepositoryImp(isLog: isLog).getItemListJSON(weather);

    json.map((e) => setState(() => items.add(e))).toList();

    return items;
  }

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
  Widget build(BuildContext context) {
    getFire.getTemp();
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
                              const Spacer(
                                flex: 10,
                              ),
                              //weather sign
                              Expanded(
                                flex: 60,
                                child: buildWeatherImage(skyCodeToString(int.parse(
                                    skyForecast))), //buildWeatherImage(rainIndex),
                              ),
                              const Spacer(
                                flex: 10,
                              ),
                              //presentation information
                              Expanded(
                                flex: 30,
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
                                            const Expanded(
                                              flex: 20,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25.0),
                                                child: ClockText(
                                                  y: true,
                                                  mth: true,
                                                  d: true,
                                                ),
                                              ),
                                            ),

                                            //hour minutes
                                            const Expanded(
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

                                            // presentation weather para
                                            Expanded(
                                              flex: 20,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: AppText(
                                                  '$temp°C  $hum%',
                                                  style: const TextStyle(
                                                    color: appPoint,
                                                  ),
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
                              const Spacer(
                                flex: 10,
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
                                child: _SettingButton(
                                  index: '온도 습도',
                                  value: '$temp도 $hum%',
                                ),
                              ),
                              //fan
                              Expanded(
                                  flex: 30,
                                  child: Row(
                                    children: [
                                      const Spacer(
                                        flex: 10,
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: AppButton(
                                          onPressed: () {
                                            if(fan=='off'){
                                              updateDataFirestore('fan', 'on');
                                              playFan();
                                            }else if(fan=='on'){
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
                                      Expanded(
                                        flex: 20,
                                        child: AppContainer(
                                          border: borderMiddle,
                                          child: innerCondition == 'good'
                                              ? Lottie.asset(
                                                  'assets/moving icon/good.json')
                                              : innerCondition == 'bad'
                                                  ? Lottie.asset(
                                                      'assets/moving icon/bad.json')
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              40.0),
                                                      child: Lottie.asset(
                                                          'assets/moving icon/indicator3.json'),
                                                    ),
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
      return const MaterialApp(
        home: Scaffold(
          body: Center(
              child: SizedBox(height: 300, width: 300, child: AppIndicator())),
        ),
      );
    }
  }
}

buildWeatherImage(String status) {
  if (kDebugMode) {
    print(status);
  }

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
  });

  final String index;
  final String value;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                index,
                style: const TextStyle(fontSize: fontMiddle),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: fontMiddle),
              ),
            ],
          ),
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
