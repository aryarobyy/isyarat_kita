import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final int? maxLine;
  final int? minLine;
  final String? hintText;

  const MyTextField({
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
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
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
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon)
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
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
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
