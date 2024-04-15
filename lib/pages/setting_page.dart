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
      debugShowCheckedModeBanner: false,
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

  final TextEditingController _coordLatController = TextEditingController();
  final TextEditingController _coordLonController = TextEditingController();

  void loadSettingPara() async {
    _actHumController.text = actHum;
    _actTempController.text = actTemp;
    _stopHumController.text = stopHum;
    _stopTempController.text = stopTemp;
    _goodLowHumController.text = goodLowHum;
    _goodLowTempController.text = goodLowTemp;
    _goodHighHumController.text = goodHighHum;
    _goodHighTempController.text = goodHighTemp;
  }

  void _send2Firestore() {
    List<Map<String, String>> data = [
      {'actHum': _actHumController.text},
      {'actTemp': _actTempController.text},
      {'stopHum': _stopHumController.text},
      {'stopTemp': _stopTempController.text},
      {'goodLowHum': _goodLowHumController.text},
      {'goodLowTemp': _goodLowTempController.text},
      {'goodHighHum': _goodHighHumController.text},
      {'goodHighTemp': _goodHighTempController.text},
    ];

    try{
      commitBatchFirestore(data);
      coordLat = double.parse(_coordLatController.text);
      coordLon = double.parse(_coordLonController.text);
      appToast(msg: '적용되었습니다.');
    }catch (e) {
      appToast(msg: '오류가 발생하였습니다.');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    loadSettingPara();
    _coordLatController.text = '$coordLat';
    _coordLonController.text = '$coordLon';
    return AppPage(
      reSizable: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 100,
                child: AppText(
                  '설정',
                  style: TextStyle(fontSize: fontMiddleBig),
                ),
              ),
              Expanded(
                flex: 500,
                child: Column(
                  children: [
                    Expanded(
                      flex: 100,
                      child: _buildSettingArea4Var(
                        title: '작동 기준',
                        sideHintLTL: '작동',
                        lt: _actTempController,
                        sideHintLTR: '°C',
                        rt: _actHumController,
                        sideHintRTR: '%',
                        sideHintLBL: '정지',
                        lb: _stopTempController,
                        sideHintLBR: '°C',
                        rb: _stopHumController,
                        sideHintRBR: '%',
                      ),
                    ),
                    Expanded(
                      flex: 100,
                      child: _buildSettingArea4Var(
                        title: '적정 기준',
                        sideHintLTL: '온도',
                        lt: _goodLowTempController,
                        sideHintLTR: '에서',
                        rt: _goodHighTempController,
                        sideHintRTR: '까지',
                        sideHintLBL: '습도',
                        sideHintLBR: '에서',
                        lb: _goodLowHumController,
                        rb: _goodHighHumController,
                        sideHintRBR: '까지',
                      ),
                    ),
                    Expanded(
                      flex: 100,
                      child: _buildPosition(),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 100,
                  child: Row(
                    children: [
                      const Spacer(flex: 100,),
                      Expanded(
                        flex: 300,
                        child: Column(
                          children: [
                            const Spacer(),
                            AppButton(
                              onPressed: () {
                                _send2Firestore();
                              },
                              text: '적용',
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const Spacer(flex: 100,),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosition() {
    return Column(
      children: [
        _SettingMiddleTitle(
          title: '위치',
        ),
        Expanded(
          flex: 300,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SideHint(text: '위도'),
                    _SettingTextFieldFittedFontSize(controller: _coordLatController, fontSize: fontSmall,),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SideHint(text: '경도'),
                    _SettingTextFieldFittedFontSize(controller: _coordLonController, fontSize: fontSetting,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingArea4Var({
    required String title,
    required TextEditingController lt,
    required TextEditingController rt,
    required TextEditingController lb,
    required TextEditingController rb,
    sideHintLTL = '',
    sideHintLTR = '',
    sideHintRTL = '',
    sideHintRTR = '',
    sideHintLBL = '',
    sideHintLBR = '',
    sideHintRBL = '',
    sideHintRBR = '',
  }) {
    return Column(
      children: [
        _SettingMiddleTitle(title: title),
        Column(
          children: [
            Row(
              children: [
                SideHint(text: sideHintLTL),
                _SettingTextFieldByExpanded(controller: lt),
                SideHint(text: sideHintLTR),
                const SizedBox(
                  width: 10,
                ),
                SideHint(text: sideHintRTL),
                _SettingTextFieldByExpanded(controller: rt),
                SideHint(text: sideHintRTR),
              ],
            ),
            Row(
              children: [
                SideHint(text: sideHintLBL),
                _SettingTextFieldByExpanded(controller: lb),
                SideHint(text: sideHintLBR),
                const SizedBox(
                  width: 10,
                ),
                SideHint(text: sideHintRBL),
                _SettingTextFieldByExpanded(controller: rb),
                SideHint(text: sideHintRBR),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingTextFieldFittedFontSize extends StatelessWidget {
  const _SettingTextFieldFittedFontSize({
    super.key,
    required this.controller,
    required this.fontSize,
  });

  final TextEditingController controller;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('',style: TextStyle(fontSize: fontSize),),
        _SettingTextFieldByExpanded(controller: controller,),
      ],
    );
  }
}

class _SettingMiddleTitle extends StatelessWidget {
  const _SettingMiddleTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppText(
      title,
    );
  }
}

class _SettingTextFieldByExpanded extends StatelessWidget {
  const _SettingTextFieldByExpanded({
    super.key,
    required this.controller,
    this.text = '',
  });

  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: AppTextField(
      text: text,
      controller: controller,
      backgroundColor: textFieldGrey,
    ));
  }
}


