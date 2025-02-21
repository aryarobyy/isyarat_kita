import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart'; // Adjust import to your project

class MyHeader extends StatelessWidget {
  final String title;

  const MyHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
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
