import 'package:flutter/material.dart';

class MyPopup2 extends StatelessWidget {
  final String title;
  final String? content;
  final String agreeText;
  final String disagreeText;
  final VoidCallback onAgreePressed;
  final VoidCallback onDisagreePressed;

  const MyPopup2({
    super.key,
    required this.title,
    this.content, // Nullable
    required this.agreeText,
    required this.disagreeText,
    required this.onAgreePressed,
    required this.onDisagreePressed,
  });

  static void show(BuildContext context, {
    required String title,
    String? content,
    required String disagreeText,
    required String agreeText,
    required VoidCallback onAgreePressed,
    required VoidCallback onDisagreePressed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: MyPopup2(
            title: title,
            content: content,
            agreeText: agreeText,
            disagreeText: disagreeText,
            onAgreePressed: onAgreePressed,
            onDisagreePressed: onDisagreePressed,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (content != null) ...[
              const SizedBox(height: 10),
              Text(
                content!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: onAgreePressed,
                  child: Text(
                    agreeText,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: onDisagreePressed,
                  child: Text(
                    disagreeText,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
