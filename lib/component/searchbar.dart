import 'package:flutter/material.dart';
import 'package:isyarat_kita/util/color.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onPressed;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const MySearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onPressed,
    this.onSubmitted,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Color(0xff465341),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: whiteColor),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: whiteColor),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            color: whiteColor,
            icon: const Icon(Icons.search),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}