import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_colors.dart';
import '../utils/app_components.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // 회원가입 성공 시 토스트 알림 표시
      appToast(msg: "회원가입에 성공했습니다.");
      // 회원가입 성공 시 페이지 이동 등의 처리
      // 예를 들어, 회원가입 후 바로 로그인 페이지로 이동할 수 있습니다.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // 회원가입 실패 시 에러 처리
      // 회원가입 성공 시 토스트 알림 표시
      appToast(msg: "회원가입에 실패했습니다.");

      print("Failed to sign up with email and password: $e");
      // 에러를 사용자에게 표시하거나 다른 처리를 수행할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  AppTextField(
                    text: '회원가입 ID',
                    controller: _emailController,
                  ),
                  AppTextField(
                    text: '회원가입 Password',
                    controller: _passwordController,
                    textHiding: true,
                  )
                ],
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: (){
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
          ],
        ),
      ),
    );
  }
}
