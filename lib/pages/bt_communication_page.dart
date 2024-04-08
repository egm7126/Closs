// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
//
// import '../utils/app_components.dart';
// import '../utils/global.dart';
//
// class BackChatPage extends StatefulWidget {
//   BackChatPage({super.key});
//
//   static void setup() {
//     //server needed
//
//     BluetoothConnection.toAddress(server.address).then((_connection) {
//       print('Connected to the device');
//       connection = _connection;
//         isConnecting = false;
//         isDisconnecting = false;
//
//       connection!.input!.listen(_onDataReceived).onDone(() {
//         // Example: Detect which side closed the connection
//         // There should be `isDisconnecting` flag to show are we are (locally)
//         // in middle of disconnecting process, should be set before calling
//         // `dispose`, `finish` or `close`, which all causes to disconnect.
//         // If we except the disconnection, `onDone` should be fired as result.
//         // If we didn't except this (no flag set), it means closing by remote.
//         if (isDisconnecting) {
//           print('Disconnecting locally!');
//         } else {
//           print('Disconnected remotely!');
//         }
//       });
//     }).catchError((error) {
//       print('Cannot connect, exception occured');
//       print(error);
//     });
//   }
//
//   static void sendFunction(String text)async{
//     if(connection != null || server != null){
//       if (text.length > 0) {
//         try {
//           connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
//           await connection!.output.allSent;
//         } catch (e) {}
//       }
//       print("send $text to ${server.name}");
//     }else{
//       print("connection is null");
//     }
//
//   }
//   static void send(String text)async{
//     if(connection != null || server != null){
//       setup();
//       sendFunction(text);
//     }else{
//       setup();
//       sendFunction(text);
//     }
//
//   }
//
//   static void _onDataReceived(Uint8List data) {
//     // Allocate buffer for parsed data
//     int backspacesCounter = 0;
//     data.forEach((byte) {
//       if (byte == 8 || byte == 127) {
//         backspacesCounter++;
//       }
//     });
//     Uint8List buffer = Uint8List(data.length - backspacesCounter);
//     int bufferIndex = buffer.length;
//
//     // Apply backspace control character
//     backspacesCounter = 0;
//     for (int i = data.length - 1; i >= 0; i--) {
//       if (data[i] == 8 || data[i] == 127) {
//         backspacesCounter++;
//       } else {
//         if (backspacesCounter > 0) {
//           backspacesCounter--;
//         } else {
//           buffer[--bufferIndex] = data[i];
//         }
//       }
//     }
//   }
//
//   static const clientID = 0;
//   static List<_Message> messages = List<_Message>.empty(growable: true);
//   static String _messageBuffer = '';
//   static bool isConnecting = true;
//   static bool get isConnected => (connection?.isConnected ?? false);
//   static bool isDisconnecting = false;
//   static final TextEditingController textEditingController = TextEditingController();
//   static final ScrollController listScrollController = ScrollController();
//
//   @override
//   _BackChatPage createState() => _BackChatPage();
// }
//
// class _Message {
//   int whom;
//   String text;
//
//   _Message(this.whom, this.text);
// }
//
// class _BackChatPage extends State<BackChatPage> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // Avoid memory leak (`setState` after dispose) and disconnect
//     // if (isConnected) {
//     //   isDisconnecting = true;
//     //   connection?.dispose();
//     //   connection = null;
//     // }
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Text('null 방지');
//   }
//
//   // void listenData() {
//   //   String containEnterString = _messageBuffer;
//   //   int enterIndex = containEnterString.indexOf("\n");
//   //
//   //   String pureString;
//   //   if (enterIndex != -1) { // If newline character found
//   //     pureString = containEnterString.substring(enterIndex + 1); // Extract the substring after the newline character
//   //   } else {
//   //     pureString = ""; // If no newline character found, set extractedString as empty string
//   //   }
//   //   stringReceived = pureString;
//   //
//   //   receivedByProtocol = ClossProtocol(stringReceived);
//   //
//   //   print("Kind: ${receivedByProtocol.kind}"); // Print the extracted kind
//   //   print("Serial: ${receivedByProtocol.serial}"); // Print the extracted serial
//   //   print("Content: ${receivedByProtocol.content}"); // Print the extracted content
//   // }
// }