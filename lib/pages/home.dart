import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/navbar.dart';
import 'package:isyarat_kita/pages/chat.dart';
import 'package:isyarat_kita/pages/kamera.dart';
import 'package:isyarat_kita/pages/kamus.dart';
import 'package:isyarat_kita/pages/setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primaryColor,
        body: Stack(
          children : [
            Positioned.fill(
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                        'assets/images/bg_dbb.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "Belajar bahasa isyarat jadi leih mudah dan menyenangkan",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Yuk gabung Sekarang!",
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            MyButton(onPressed: () {}, text: "Daftar"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: whiteColor,
                height: 300,
                alignment: Alignment.center,
                child: Text(
                  "WWJWJW",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
