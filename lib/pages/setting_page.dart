import 'package:c1/utils/app_components.dart';
import 'package:c1/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

bool tog = true;

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
  final TextEditingController _actTemp = TextEditingController();
  final TextEditingController _actHum = TextEditingController();
  final TextEditingController _stopTemp = TextEditingController();
  final TextEditingController _stopHum = TextEditingController();

  final TextEditingController _goodLowTemp = TextEditingController();
  final TextEditingController _goodLowHum = TextEditingController();
  final TextEditingController _goodHighTemp = TextEditingController();
  final TextEditingController _goodHighHum = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
        child: Column(
      children: [
        AppText(
          '설정',
          minFontSize: fontBig,
        ),
        const Spacer(
          flex: 10,
        ),
        //setting area
        Expanded(
          flex: 20,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        AppText(
                          '환기 기준',
                          minFontSize: fontMiddle,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 10,
                                    child: AppTextField(
                                      text: '작동 온도',
                                      controller: _actTemp,
                                      backgroundColor: textFieldGrey,
                                    )),
                                Expanded(
                                    flex: 10,
                                    child: AppTextField(
                                      text: '작동 습도',
                                      controller: _actHum,
                                      backgroundColor: textFieldGrey,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 10,
                                    child: AppTextField(
                                      text: '정지 온도',
                                      controller: _stopTemp,
                                      backgroundColor: textFieldGrey,
                                    )),
                                Expanded(
                                    flex: 10,
                                    child: AppTextField(
                                      text: '정지 습도',
                                      controller: _stopHum,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        AppText(
                          '적정도 기준',
                          style: TextStyle(fontSize: fontMiddle),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildGoodConditionRow('온도'),
                            buildGoodConditionRow('습도'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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

  Row buildGoodConditionRow(String para, ) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: AppText(
              para,
              style: TextStyle(
                  fontSize: fontSmall,
                  fontWeight: FontWeight.normal,
                  color: fontGrey),
            )),
        Expanded(
            flex: 10,
            child: AppTextField(
              text: '에서',
              controller: _actTemp,
              backgroundColor: textFieldGrey,
            )),
        Expanded(
            flex: 10,
            child: AppTextField(
              text: '까지',
              controller: _actHum,
              backgroundColor: textFieldGrey,
            )),
      ],
    );
  }
}
