import 'package:c1/pages/sign_up_page.dart';
import 'package:c1/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/appTools.dart';
import '../utils/app_colors.dart';
import '../utils/app_components.dart';
// import '../utils/bt_relations/SelectBondedDevicePage.dart';
import '../utils/global.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      // 회원가입 성공 시 토스트 알림 표시
      appToast(msg: "회원가입에 성공했습니다.");

      // 회원가입 성공 시 페이지 이동 등의 처리
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const DashBoardPage()),
      );

    } catch (e) {
      // 회원가입 실패 시 에러 처리
      // 회원가입 성공 시 토스트 알림 표시
      appToast(msg: "회원가입에 실패했습니다.");

      appPrint("Failed to sign up with email and password: $e");
      // 에러를 사용자에게 표시하거나 다른 처리를 수행할 수 있습니다.
    }
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      appToast(msg: "로그인 되었습니다.");

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const DashBoardPage()),
      );
    } catch (e) {
      // 로그인 실패 시 에러 처리
      appToast(msg: "로그인에 실패했습니다.");

      appPrint("Failed to sign in with email and password: $e");

      // 에러를 사용자에게 표시하거나 다른 처리를 수행할 수 있습니다.
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackWhite,
      //resizeToAvoidBottomInset: false, // 키보드가 나타날 때 화면 크기를 조정하지 않음
      body: AppPage(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //person icon
              const SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: AppContainer(
                          border: borderTiny,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ),
                          )),
                    )
                  ],
                ),
              ),
              const Spacer(
                flex: 5,
              ),
              //logo
              Expanded(
                flex: 8,
                child: SizedBox(
                    height: 10,
                    width: 10,
                    child: Image.asset('assets/logo/name logo-cutout.png')),
              ),
              const Spacer(
                flex: 3,
              ),
              //login textfield
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    AppTextField(
                      text: '로그인 ID',
                      controller: _usernameController,
                    ),
                    AppTextField(
                      text: '로그인 Password',
                      controller: _passwordController,
                      textHiding: true,
                    )
                  ],
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _signUp();
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: appPoint,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _signIn,
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: appPoint,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 10, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
