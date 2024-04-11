import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/appTools.dart';
import '../utils/app_colors.dart';
import '../utils/app_components.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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

      appToast(msg: "회원가입에 성공했습니다.");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      appToast(msg: "회원가입에 실패했습니다.");
      appPrint("Failed to sign up with email and password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
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
          const SizedBox(height: 16.0),
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
      )
    );
  }
}
