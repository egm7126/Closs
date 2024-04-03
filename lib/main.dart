import 'package:c1/pages/dashboard_page.dart';
import 'package:c1/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 필수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: FutureBuilder(
            future: _getLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // snapshot.data가 true라면, 사용자가 로그인 상태이므로 HomeScreen을 보여줍니다. // 그렇지 않다면 LoginScreen을 보여줍니다.
                return snapshot.data == true
                    ? const LoginPage()
                    : const DashBoardPage();
              } else {
                // 비동기 작업이 아직 완료되지 않았다면 로딩 인디케이터를 보여줍니다.
                return const CircularProgressIndicator();
              }
            }) //const Login(),
        );
  }

  // 비동기 함수 _getLoginStatus를 정의합니다.
  // 이 함수는 shared_preferences를 사용하여 저장된 로그인 상태를 불러옵니다.
  Future _getLoginStatus() async {
    // SharedPreferences의 인스턴스를 비동기적으로 가져옵니다.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 'isLoggedIn' 키를 사용하여 저장된 로그인 상태를 불러옵니다.
    // 해당 키가 없다면 기본값으로 false를 반환합니다.
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
