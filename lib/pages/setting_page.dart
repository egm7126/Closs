import 'package:c1/utils/app_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
        child: Column(
      children: [
        const Spacer(
          flex: 10,
        ),
        //fan relations
        Expanded(
          flex: 20,
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
        const Spacer(
          flex: 10,
        ),
      ],
    ));
  }
}
