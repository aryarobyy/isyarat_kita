import 'package:flutter/material.dart';

extension SizeExtension on BuildContext { //mediaQuery & persen
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double percentWidth(double percent) => screenWidth * percent / 100;
  double percentHeight(double percent) => screenHeight * percent / 100;
}