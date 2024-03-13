import 'package:closs_b1/pages/settingPage.dart';
import 'package:closs_b1/utils/appColors.dart';
import 'package:closs_b1/utils/appComponents.dart';
import 'package:closs_b1/utils/appConstansts.dart';
import 'package:flutter/material.dart';

import '../utils/appTools.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        fontFamily: 'RoundAppFont',
      ),
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
                                child: buildWeatherImage('rainy')),//#todo
                            const Spacer(
                              flex: 10,
                            ),
                            //presentation information
                            const SizedBox(
                              height: 200,
                              width: 200,
                              child: AppContainer(
                                border: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(
                                      flex: 10,
                                    ),
                                    Text(
                                      'AM 07:30',
                                      style: TextStyle(fontSize: fontMiddle),
                                    ),
                                    Text(
                                      '1987년 7월 30일',
                                      style: TextStyle(fontSize: fontMiddle),
                                    ),
                                    Spacer(
                                      flex: 30,
                                    ),
                                    //presentation weather para
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Text(
                                          '23도',
                                          style: TextStyle(
                                            color: appPoint,
                                            fontSize: fontMiddleBig,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '60%',
                                          style: TextStyle(
                                            color: appPoint,
                                            fontSize: fontMiddleBig,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    Spacer(
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
                            OtherCityCard(cityCountry: '대한민국', cityName: '부산',hum: '60%', temp: '25도',),
                            OtherCityCard(cityCountry: '대한민국', cityName: '서울',hum: '40%', temp: '18도',),
                            OtherCityCard(cityCountry: '미국', cityName: '뉴욕',hum: '30%', temp: '24도',),
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
                        child: const Column(
                          children: [
                            Spacer(
                              flex: 10,
                            ),
                            Text(
                              '현재 가구 내부',
                              style: TextStyle(fontSize: fontMiddleBig),
                            ),
                            Spacer(
                              flex: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                _SettingButton(index: '온도', value: '20도',),
                                Spacer(),
                                _SettingButton(index: '습도', value: '85%',),
                                Spacer(),
                              ],
                            ),
                            Spacer(
                              flex: 10,
                            ),
                            AppContainer(
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
                                        color: appPoint, fontSize: fontMiddle),
                                  ),
                                )),
                            Spacer(
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
  }

  Image buildWeatherImage(String status) {
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
    super.key,
    required this.index,
    required this.value,
  });
  
  final String index;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
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
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                index,
                style:
                    TextStyle(fontSize: fontMiddle),
              ),
              Text(
                value,
                style:
                    TextStyle(fontSize: fontMiddle),
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
        child: AppContainer(border: 10, child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(cityName, style: const TextStyle(fontSize: fontMiddle),),
                  const SizedBox(width: 5,),
                  Text(cityCountry, style: const TextStyle(fontSize: fontLittle, color: fontGrey),),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("온도", style: TextStyle(fontSize: fontLittle, color: fontGrey),),
                        Text(temp, style: const TextStyle(fontSize: fontSmall),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("습도", style: TextStyle(fontSize: fontLittle, color: fontGrey),),
                        Text(hum, style: const TextStyle(fontSize: fontSmall),),
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