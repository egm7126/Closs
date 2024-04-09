import 'package:auto_size_text/auto_size_text.dart';
import 'package:c1/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'app_colors.dart';
import 'app_constants.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    super.key,
    required this.child,
    this.backgroundColor = appBackWhite,
  });

  final Widget child;
  final Color backgroundColor;

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

class ClossProtocol {
  String kind = '';
  String serial = '';
  String content = '';

  ClossProtocol(String data) {
    RegExp regex =
        RegExp(r"@k(.*?)@s(.*?)@c(.*)"); // Define regular expression pattern
    Match? match =
        regex.firstMatch(data); // Find the first match in the input data

    if (match != null) {
      kind = match.group(1)!; // Extract the kind
      serial = match.group(2)!; // Extract the serial
      content = match.group(3)!; // Extract the content
    }
  }
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
        child: AutoSizeText(
          text,
          maxLines: maxLines,
          minFontSize: minFontSize,
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
