import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const MyText(
      this.text, {
        Key? key,
        this.fontSize = 20,
        this.color = Colors.white,
        this.fontWeight,
        this.textAlign,
        this.overflow,
        this.maxLines,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final defaultFontStyle = googleFontStyle ?? GoogleFonts.lato();

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
