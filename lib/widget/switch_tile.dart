import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/text.dart';

class MySwitchTile extends StatefulWidget {
  final String title;
  final String? subTitle;
  final bool toggle;

  final ValueChanged<bool>? onChanged;

  const MySwitchTile({
    Key? key,
    required this.title,
    this.subTitle,
    this.toggle = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<MySwitchTile> createState() => _MySwitchTileState();
}

class _MySwitchTileState extends State<MySwitchTile> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.toggle;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  widget.title,
                  fontSize: 16.0,
                ),
                const SizedBox(height: 4.0),
                if (widget.subTitle != null && widget.subTitle!.isNotEmpty)
                  MyText(
                    widget.subTitle!,
                    fontSize: 14.0,
                    color: Colors.white54,
                  ),
              ],
            ),
          ),

          widget.toggle
              ? Switch(
            value: isSwitched,
            onChanged: (bool value) {
              setState(() {
                isSwitched = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            activeColor: Colors.white,
            activeTrackColor: secondaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
