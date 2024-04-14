import 'package:c1/pages/dashboard_page.dart';
import 'package:c1/pages/login_page.dart';
import 'package:c1/utils/appTools.dart';
import 'package:c1/utils/app_components.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 필수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      offInnerGap: true,
      child: FutureBuilder<Widget>(
        future: choosePage(),
        builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasData){
                return  const AppFrame();
              }else{
                return  const AppIndicator();
              }
            } else {
              return  const AppIndicator();
            }
        },
      )
    );

  }

  Future<Widget> choosePage() async{
    if(await getLoginStatus()){
      //when client have login log
      return const DashBoardPage();
    }
    return const LoginPage();
  }
}
