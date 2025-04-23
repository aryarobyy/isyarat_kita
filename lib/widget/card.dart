import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/text.dart';

class MyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double width;
  final double height;
  final Color? color;

  const MyCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.width = double.infinity,
    this.height = 100,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = color ?? cs.surface;
    final textColor = cs.onSurface;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,                           // <— warna latar
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(

            child: MyText(
              title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          MyText(
            subtitle,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textColor.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}