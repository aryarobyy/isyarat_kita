import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class MyTextField2 extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final int? maxLine;
  final int? minLine;
  final String? hintText;
  final Color? textColor;
  final Color? outlineColor; // Warna untuk underline
  final ValueChanged<String>? onSubmitted;

  const MyTextField2({
    Key? key,
    required this.controller,
    required this.name,
    this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    this.maxLine = 1,
    this.minLine = 1,
    this.hintText,
    this.textColor,
    this.outlineColor,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<MyTextField2> createState() => _MyTextField2State();
}

class _MyTextField2State extends State<MyTextField2> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        enabled: true,
        controller: widget.controller,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.inputType == TextInputType.multiline
            ? TextInputType.multiline
            : widget.inputType,
        maxLines: widget.maxLine,
        minLines: widget.minLine,
        obscureText: _obscureText,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: blackColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          isDense: true,
          labelText: widget.name,
          hintText: widget.hintText,
          counterText: "",
          labelStyle: TextStyle(color: widget.textColor ?? whiteColor),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.outlineColor ?? whiteColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.outlineColor ?? whiteColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.outlineColor ?? whiteColor),
          ),
        ),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
