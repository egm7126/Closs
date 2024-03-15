import 'dart:async';
import 'package:closs_b1/utils/appComponents.dart';
import 'package:closs_b1/utils/appConstansts.dart';
import 'package:flutter/material.dart';
import '../utils/appTools.dart';
import '../utils/globalVars.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppPage(
        child: Column(
      children: [
        Spacer(
          flex: 10,
        ),
        //fan relations
        Expanded(
          flex: 10,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: AppWidgetButton(
                  onPressed: () {},
                  child: Opacity(
                    opacity: fan ? 1 : 0.5,
                    child: Image.asset('assets/icon/wind.png'),
                  ),
                ),
              ),
              Spacer(
                flex: 5,
              ),
              Expanded(
                flex: 30,
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: AppTextField(
                                      text: '작동 온도', controller: _actTemp)),
                              Expanded(
                                  flex: 10,
                                  child: AppTextField(
                                      text: '작동 습도', controller: _actHum)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: AppTextField(
                                      text: '정지 온도', controller: _stopTemp)),
                              Expanded(
                                  flex: 10,
                                  child: AppTextField(
                                      text: '정지 습도', controller: _stopHum)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //time relations
        Expanded(
            flex: 10,
            child: Center(
              child: AppContainer(
                border: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClockWidget(),
                ),
              ),
            )),
        const Spacer(
          flex: 10,
        ),
      ],
    ));
  }
}
