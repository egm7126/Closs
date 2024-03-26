import 'dart:async';
import 'package:closs_b1/utils/app_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/appTools.dart';
import '../utils/bt_relations/SelectBondedDevicePage.dart';
import '../utils/global_vars.dart';
import 'bt_communication_page.dart';

main(){
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

  Position? position;
  var grid;

  //put to position
  Future<void> _getPastPosition() async {
    appToast(msg: '이전 위치 정보를 이용합니다.');

    try {
      final fetchedPosition = await getPastGPS();
      setState(() {
        position = fetchedPosition;
        appToast(msg: '위치 정보를 새로고침했습니다.');
      });
    } catch (e) {
      appToast(msg: '위치 정보를 가져오는 동안 오류가 발생했습니다.');
    }
  }

  Future<void> _getCurrentPosition() async {
    appToast(msg: '위치 정보를 탐색합니다.');

    try {
      final fetchedPosition = await getCurrentGPS(); //받는게 시간이 걸림
      setState(() {
        position = fetchedPosition;
        appToast(msg: '위치 정보를 새로고침했습니다.');
      });
    } catch (e) {
      appToast(msg: '위치 정보를 가져오는 동안 오류가 발생했습니다.');
    }
  }

  //put to grid
  Future<void> _getGrid() async{
    _getPastPosition();
    grid = GridGpsConvertor.gpsToGRID(position != null ? position!.latitude: 0, position != null ? position!.longitude: 0);
  }

  @override
  void initState() {
    super.initState();
    _getGrid();
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
              const Spacer(
                flex: 5,
              ),
              Expanded(
                flex: 20,
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
        //time relations
        const Expanded(
            flex: 10,
            child: Center(
              child: AppContainer(
                border: 10,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ClockText(
                    frontString: '현재시간 ',
                    y: true,
                    mth: true,
                    d: true,
                    h: true,
                    min: true,
                    s: true,
                    displayType: 'kor',
                  ),
                ),
              ),
            )),
        Expanded(
            flex: 10,
            child: Center(
              child: AppButton(
                onPressed: () {
                  _getCurrentPosition();
                },
                text: position != null
                    ? '${position!.latitude}, ${position!.longitude}'
                    : 'Loading...',
              ),
            )),
        Expanded(
            flex: 10,
            child: Center(
              child: AppContainer(
                border: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GeoGridText(),
                ),
              ),
            )),
        Expanded(
            flex: 10,
            child: Center(
              child: AppButton(
                onPressed: () async {
                  final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(
                            checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    print('Connect -> selected ' + selectedDevice.address);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatPage(server: selectedDevice);
                        },
                      ),
                    );
                  } else {
                    print('Connect -> no device selected');
                  }
                },
                text: '블루투스 통신 내용',
              ),
            )),
        const Spacer(
          flex: 10,
        ),
      ],
    ));
  }
}
