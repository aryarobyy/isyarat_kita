import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isyarat_kita/component/auth_button.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/popup.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/pages/home.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/widget/snackbar.dart';

part 'login.dart';
part 'register.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _isLogin = true;

  void togglePages() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/bg_top.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/bg_bottom.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthButton(
                        isLogin: _isLogin,
                        onToggle: (bool isLogin) {
                          setState(() {
                            _isLogin = isLogin;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _isLogin ? Login(onTap: togglePages,) : Register(onTap: togglePages,) ,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
