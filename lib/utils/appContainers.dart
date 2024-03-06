import 'package:flutter/material.dart';
import 'appColors.dart';

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

class AppContainer2 extends StatelessWidget {
  const AppContainer2({super.key,
    required this.child,
    required this.border,
  });

  final Widget child;
  final double border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appBackWhite,
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