import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MySnackbar {
  final String title;
  final String text;
  final String type;

  MySnackbar({
    required this.title,
    required this.text,
    required this.type,
  });

  ContentType _getContentType(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return ContentType.success;
      case 'failure':
        return ContentType.failure;
      case 'warning':
        return ContentType.warning;
      case 'help':
        return ContentType.help;
      default:
        throw ArgumentError('Invalid snackbar type: $type');
    }
  }

  void show(BuildContext context) {
    if (title.isEmpty || text.isEmpty || type.isEmpty) {
      throw ArgumentError("Title, text, and type must not be empty.");
    }

    final snackbar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: text,
        contentType: _getContentType(type),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
