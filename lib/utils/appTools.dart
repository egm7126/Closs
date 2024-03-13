import 'package:flutter/material.dart';

import 'appComponents.dart';

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: child,
    );
  }
}