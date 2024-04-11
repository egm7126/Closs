import 'dart:ui';

import 'package:c1/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '../pages/dashboard_page.dart';
import '../pages/setting_page.dart';
import 'appTools.dart';
import 'app_colors.dart';
import 'app_constants.dart';
import 'global.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  String _userName = 'hi';
  bool _didLogin = false;

  void getLogin() async {
    _didLogin = await getLoginStatus();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const DashBoardPage(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    getLogin();
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                });
              },
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: _isDrawerOpen ? 0.5 : 1.0,
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          if (_isDrawerOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDrawerOpen = false;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          if (_isDrawerOpen)
            buildSideMenu(context),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: appBlue,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Dashboard', // label 추가
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Setting', // label 추가
        ),
      ],
    );
  }

  Drawer buildSideMenu(BuildContext context) {
    return Drawer(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isDrawerOpen ? MediaQuery.of(context).size.width * 0.6 : 0,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: appBlue,
                    ),
                    child: Text(
                      '사용자 정보',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontMiddle,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('프로필'),
                    onTap: () {
                      // 프로필 페이지로 이동하거나 해당 기능 구현
                      // 여기에 코드 추가
                    },
                  ),
                  ListTile(
                    title: const Text('설정'),
                    onTap: () {
                      // 설정 페이지로 이동하거나 해당 기능 구현
                      // 여기에 코드 추가
                    },
                  ),
                  ListTile(
                    title: Text('로그인 페이지'),
                    onTap: () {
                      setState(() {
                        _isDrawerOpen = false;
                        // Drawer를 닫습니다.
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}


class AppPage extends StatefulWidget {
  const AppPage({
    super.key,
    required this.child,
    this.backgroundColor = appBackWhite,
    this.offInnerGap = false,
  });

  final Widget child;
  final Color backgroundColor;
  final bool offInnerGap;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'AppFont',
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        colorSchemeSeed: Colors.white,
        scaffoldBackgroundColor: widget.backgroundColor,
      ),
      home: Scaffold(
        body: widget.offInnerGap
            ? Center(child: widget.child)
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Center(child: widget.child),
                ),
              ),
      ),
    );
  }
}

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
    this.border = 10,
    this.color = Colors.white,
  });

  final Widget child;
  final double border;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(border),
        boxShadow: [
          BoxShadow(
            color: color == Colors.white ? appPoint.withOpacity(0.08) : appPoint.withOpacity(0.00),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // 변경된 위치에 그림자 효과 적용
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppTextField extends StatelessWidget {
  AppTextField({
    super.key,
    required this.text,
    required this.controller,
    this.textHiding = false,
    this.backgroundColor = Colors.white,
  });

  final String text;
  TextEditingController controller = TextEditingController();
  final bool textHiding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppContainer(
          border: borderMiddle,
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CupertinoTextField(
              placeholder: text,
              controller: controller,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: backgroundColor
              ),
              obscureText: textHiding,
            ),
          )),
    );
  }
}

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.text = '',
    this.child = const Text(''),
    this.color = appBlue,
    this.width = 0,
    this.height = 0,
  });

  final VoidCallback onPressed;
  final String text;
  final Widget child;
  final Color color;
  final double width;
  final double height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppContainer(
        border: borderMiddle,
        child: CupertinoButton(
          onPressed: widget.onPressed,
          color: widget.color,
          borderRadius: BorderRadius.circular(20.0),
          // 버튼의 모서리를 둥글게 만듭니다.
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: buildChild(),
        ),
      ),
    );
  }

  Widget buildChild() {
    if(widget.text==''){
      return widget.child;
    }else{
      Widget returnWidget;
      if(widget.width>0){
        returnWidget = SizedBox(width: widget.width, child: Center(child: Text(widget.text)),);
      }else if(widget.height>0) {
        returnWidget = SizedBox(height: widget.height, child: Center(child: Text(widget.text)),);
      }else{
        returnWidget = Center(child: Text(widget.text));
      }
      return returnWidget;
    }
  }
}

appToast({required String msg}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.maxLines = 1,
    this.style = const TextStyle(),
    this.minFontSize = 12,
  });

  final String text;
  final int maxLines;
  final TextStyle style;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    if (style.fontSize == null) {
      return FittedBox(
        child: Text(
          text,
          style: style,
        ),
      );
    }
    return Text(
      text,
      style: style,
    );
  }
}

class AppIndicator extends StatelessWidget {
  const AppIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/moving icon/indicatorBlueCircle.json');
  }
}

class SideHint extends StatelessWidget {
  const SideHint({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      style: const TextStyle(
          fontSize: fontSmall, fontWeight: FontWeight.normal, color: fontGrey),
    );
  }
}