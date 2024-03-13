import 'package:closs_b1/pages/loginPage.dart';
import 'package:closs_b1/utils/appColors.dart';
import 'package:closs_b1/utils/appComponents.dart';
import 'package:closs_b1/utils/appTools.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        fontFamily: 'AppFont',
      ),
      home: const Login(),
    );
  }
}