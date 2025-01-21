import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
    );
  }
}
