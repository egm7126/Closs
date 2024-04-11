import 'package:c1/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/appTools.dart';
import '../utils/app_colors.dart';
import '../utils/app_components.dart';
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

      appToast(msg: "회원가입에 성공했습니다.");

      setPrefs('didLogin', 'true');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const AppFrame()),
      );

    } catch (e) {
      appToast(msg: "회원가입에 실패했습니다.");
      appPrint("Failed to sign up with email and password: $e");
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

      setPrefs('didLogin', 'true');

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const AppFrame()),
      );
    } catch (e) {
      appToast(msg: "로그인에 실패했습니다.");
      appPrint("Failed to sign in with email and password: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
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
      );
  }
}
