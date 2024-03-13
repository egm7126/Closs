import 'package:closs_b1/utils/appTools.dart';
import 'package:flutter/material.dart';

import '../utils/appColors.dart';
import '../utils/appComponents.dart';
import 'dashboardPage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackWhite,
      //resizeToAvoidBottomInset: false, // 키보드가 나타날 때 화면 크기를 조정하지 않음
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                      )
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: 5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashBoardPage()),
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
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 10, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
