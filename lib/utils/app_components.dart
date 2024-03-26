import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_colors.dart';
import 'app_constants.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    super.key,
    required this.child,
  });

  final Widget child;

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
        scaffoldBackgroundColor: appBackWhite,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: widget.child,
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
    required this.border,
  });

  final Widget child;
  final double border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(border),
        boxShadow: [
          BoxShadow(
            color: appPoint.withOpacity(0.08),
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
  });

  final String text;
  TextEditingController controller = TextEditingController();
  final bool textHiding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppContainer(
          border: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CupertinoTextField(
              placeholder: text,
              controller: controller,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      border: 20,
      child: CupertinoButton(
        onPressed: widget.onPressed,
        color: appBlue,
        borderRadius: BorderRadius.circular(20.0),
        // 버튼의 모서리를 둥글게 만듭니다.
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: fontButtonMiddle,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AppWidgetButton extends StatefulWidget {
  const AppWidgetButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<AppWidgetButton> createState() => _AppWidgetButtonState();
}

class _AppWidgetButtonState extends State<AppWidgetButton> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      border: 20,
      child: CupertinoButton(
        onPressed: widget.onPressed,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        // 버튼의 모서리를 둥글게 만듭니다.
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: widget.child,
      ),
    );
  }
}

appToast({required String msg}){
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}