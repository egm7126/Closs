import 'package:closs_b1/utils/app_components.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

bool fan = false;
String stringReceived ='';
String stringSend = '';
ClossProtocol receivedByProtocol = ClossProtocol('');
late final BluetoothDevice? selectedDevice;