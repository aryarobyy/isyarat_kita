import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double? width;
  final double? height;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 330,
      height: height ?? 50,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(

            backgroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
      ),
    );
  }
}
