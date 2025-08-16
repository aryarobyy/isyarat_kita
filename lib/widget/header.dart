import 'package:flutter/material.dart';
import 'package:isyarat_kita/util/color.dart'; // Adjust import to your project

class MyHeader extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const MyHeader({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Image.asset(
              "assets/images/back-button.png",
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
