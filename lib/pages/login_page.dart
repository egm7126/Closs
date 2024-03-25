import 'package:closs_b1/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_components.dart';
import 'dashboard_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text
      );
      appToast(msg: "로그인 되었습니다.");
      // 로그인 성공 시 페이지 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashBoardPage()),
      );
    } catch (e) {
      // 로그인 실패 시 에러 처리
      appToast(msg: "로그인에 실패했습니다.");
      if (kDebugMode) {
        print("Failed to sign in with email and password: $e");
      }
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
              const SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: AppContainer(
                          border: 5,
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
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
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
                      onPressed: _login,
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
