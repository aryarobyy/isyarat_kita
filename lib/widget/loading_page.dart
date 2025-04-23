import 'dart:ui';
import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color backgroundColor;
  final double opacity;
  final Color loadingColor;

  const MyLoading({
    Key? key,
    required this.isLoading,
    required this.child,
    this.backgroundColor = Colors.black,
    this.opacity = 0.4,
    this.loadingColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: backgroundColor.withOpacity(opacity),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Center(
                  child: CircularProgressIndicator(
                    color: loadingColor,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}