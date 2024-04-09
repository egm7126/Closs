import 'package:c1/utils/app_components.dart';
import 'package:c1/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/appTools.dart';
import '../utils/app_colors.dart';
import '../utils/global.dart';

main() {
  runApp(const SettingTest());
}

class SettingTest extends StatelessWidget {
  const SettingTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SettingPage(),
      ),
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _actTempController = TextEditingController();
  final TextEditingController _actHumController = TextEditingController();
  final TextEditingController _stopTempController = TextEditingController();
  final TextEditingController _stopHumController = TextEditingController();

  final TextEditingController _goodLowTempController = TextEditingController();
  final TextEditingController _goodLowHumController = TextEditingController();
  final TextEditingController _goodHighTempController = TextEditingController();
  final TextEditingController _goodHighHumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 각 텍스트 필드에 대한 변경 사항을 감지하여 변수를 업데이트
  }

  void getPara2TextController() async {
    _actHumController.text = await readDataFirestore('actHum');
    _actTempController.text = await readDataFirestore('actTemp');
    _stopHumController.text = await readDataFirestore('stopHum');
    _stopTempController.text = await readDataFirestore('stopTemp');
    _goodLowHumController.text = await readDataFirestore('goodLowHum');
    _goodLowTempController.text = await readDataFirestore('goodLowTemp');
    _goodHighHumController.text = await readDataFirestore('goodHighHum');
    _goodHighTempController.text = await readDataFirestore('goodHighTemp');
  }

  void put2Global(){
    _goodLowHumController.text = goodLowHum;
    _goodLowTempController.text = goodLowTemp;
    _goodHighHumController.text = goodHighHum;
    _goodHighTempController.text = goodHighTemp;
  }

  @override
  Widget build(BuildContext context) {
    getPara2TextController();
    put2Global();
    return AppPage(
        child: Column(
      children: [
        const AppText(
          '설정',
          minFontSize: fontBig,
        ),
        SizedBox(height: 30),
        //setting area
        Expanded(
          flex: 20,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Spacer(
                                  flex: 3,
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Center(
                                    child: AppText(
                                      '환기 기준',
                                      style: TextStyle(fontSize: fontMiddle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 3,
                                        child: AppText(
                                          '작동',
                                          style: TextStyle(
                                              fontSize: fontSmall,
                                              fontWeight: FontWeight.normal,
                                              color: fontGrey),
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '작동 온도',
                                          controller: _actTempController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                    AppText(
                                      '°C', style: TextStyle(
                                      color: fontGrey
                                    ),
                                    ),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '작동 습도',
                                          controller: _actHumController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: AppText(
                                          '정지',
                                          style: TextStyle(
                                              fontSize: fontSmall,
                                              fontWeight: FontWeight.normal,
                                              color: fontGrey),
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '정지 온도',
                                          controller: _stopTempController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '정지 습도',
                                          controller: _stopHumController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    width: 16,
                  ),
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Spacer(
                                  flex: 3,
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Center(
                                    child: AppText(
                                      '적정도 기준',
                                      style: TextStyle(fontSize: fontMiddle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //온도
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: AppText(
                                          '온도',
                                          style: TextStyle(
                                              fontSize: fontSmall,
                                              fontWeight: FontWeight.normal,
                                              color: fontGrey),
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '',
                                          controller: _goodLowTempController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '',
                                          controller: _goodHighTempController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                  ],
                                ),
                                //습도
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: AppText(
                                          '습도',
                                          style: TextStyle(
                                              fontSize: fontSmall,
                                              fontWeight: FontWeight.normal,
                                              color: fontGrey),
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '',
                                          controller: _goodLowHumController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                    Expanded(
                                        flex: 10,
                                        child: AppTextField(
                                          text: '',
                                          controller: _goodHighHumController,
                                          backgroundColor: textFieldGrey,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              AppButton(
                onPressed: () {
                  List<Map<String, String>> data = [
                    {'goodHighHum': _goodHighHumController.text},
                    {'goodHighTemp': _goodHighTempController.text},
                    {'goodLowHum': _goodLowHumController.text},
                    {'goodLowTemp': _goodLowTempController.text},
                    {'actHum': _actHumController.text},
                    {'actTemp': _actTempController.text},
                    {'stopHum': _stopHumController.text},
                    {'stopTemp': _stopTempController.text},
                  ];
                  commitBatchFirestore(data);
                },
                text: '적용',
                width: MediaQuery.of(context).size.width / 3,
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 10,
        ),
      ],
    ));
  }
}
