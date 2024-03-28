import 'dart:ffi';
import 'dart:isolate';
import 'package:closs_b1/pages/setting_page.dart';
import 'package:closs_b1/utils/app_colors.dart';
import 'package:closs_b1/utils/app_components.dart';
import 'package:closs_b1/utils/app_constants.dart';
import 'package:closs_b1/utils/global_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:korea_weather_api/korea_weather_api.dart';
import '../utils/appTools.dart';
import '../utils/bt_relations/ChatPage.dart';



class DashBoardPage extends StatefulWidget {
  const DashBoardPage({
    super.key,
  });

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<ItemSuperNct>> superNctItems; //날씨 데이터 행렬을 받을 녀석
  late Future<List<ItemSuperFct>> superFctItems;
  String hum = '';
  String temp = '';
  String rainIndex = '';
  String skyForecast = '';

  String innerHum = receivedByProtocol.content;

  String innerTemp = receivedByProtocol.content;

  //GeoCrdText geoCrdText;

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
  }

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

  Future<void> makeInstanceForGeoCrdText() async {
    //geoCrdText = GeoCrdText();
  }

  void backgroundTask(SendPort sendPort) {
    if (selectedDevice != null) {
      runApp(ChatPage(server: selectedDevice!));
    }
  }

  void startBackgroundTask() async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(backgroundTask, receivePort.sendPort);
    print('backround program begin');
  }

  @override
  void initState() {
    super.initState();

    //startBackgroundTask();

    //카테고리별 날씨데이터 행렬을 받기
    superNctItems = getSuperNctListJson();
    superFctItems = getSuperFctListJson();

    /// getItemNctListJson
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

    /// getItemFctListJson
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
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: AppContainer(
                                  border: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(
                                        flex: 10,
                                      ),
                                      const ClockText(
                                        y: true,
                                        mth: true,
                                        d: true,
                                        style: TextStyle(
                                            fontSize: fontMiddle,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const ClockText(
                                        h: true,
                                        min: true,
                                        style: TextStyle(
                                            fontSize: 60,
                                            fontFamily: 'PrettyAppFont',
                                            fontWeight: FontWeight.bold),
                                        displayType: ':',
                                      ),
                                      const Spacer(
                                        flex: 30,
                                      ),
                                      //
                                      //
                                      // presentation weather para
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          Text(
                                            '$temp°C',
                                            style: const TextStyle(
                                              color: appPoint,
                                              fontSize: fontMiddleBig,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$hum%',
                                            style: const TextStyle(
                                              color: appPoint,
                                              fontSize: fontMiddleBig,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      //Text(geoCrdText.getLocationString()),
                                      const Spacer(
                                        flex: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(
                                flex: 10,
                              ),
                            ],
                          ),
                        ),
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              OtherCityCard(
                                cityCountry: '대한민국',
                                cityName: '부산',
                                hum: '60%',
                                temp: '25도',
                              ),
                              OtherCityCard(
                                cityCountry: '대한민국',
                                cityName: '서울',
                                hum: '40%',
                                temp: '18도',
                              ),
                              OtherCityCard(
                                cityCountry: '미국',
                                cityName: '뉴욕',
                                hum: '30%',
                                temp: '24도',
                              ),
                            ],
                          ),
                        ),
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
                              const Text(
                                '현재 가구 내부',
                                style: TextStyle(fontSize: fontMiddleBig),
                              ),
                              const Spacer(
                                flex: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  _SettingButton(
                                    index: '온도',
                                    value: innerTemp,
                                  ),
                                  SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: Text(temp),
                                  ),
                                  const Spacer(),
                                  _SettingButton(
                                    index: '습도',
                                    value: innerHum,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const Spacer(
                                flex: 10,
                              ),
                              const AppContainer(
                                  border: 40,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 12.0,
                                        bottom: 8.0),
                                    child: Text(
                                      '환기가 필요합니다.',
                                      style: TextStyle(
                                          color: appPoint,
                                          fontSize: fontMiddle),
                                    ),
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
          body: Center(child: Text("로딩 중...")),
        ),
      );
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
        border: 10,
        child: Square(
          size: 100,
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
            border: 10,
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
