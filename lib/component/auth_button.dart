import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class AuthButton extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onToggle;

  const AuthButton({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  Widget _buildButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isActive ? secondaryColor : whiteColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? whiteColor : secondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
        border: Border.all(
          color: secondaryColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          _buildButton(
            "Login",
            isLogin,
                () => onToggle(true),
          ),
          _buildButton(
            "Register",
            !isLogin,
                () => onToggle(false),
          ),
        ],
      ),
    );
  }
}
