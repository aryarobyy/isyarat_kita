import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/navbar.dart';
import 'package:isyarat_kita/pages/chat/chat.dart';
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
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primaryColor,
        body: Stack(
          children : [
            Positioned.fill(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bg_db.png',
                      fit: BoxFit.cover,
                      height: 450,
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
                height: size.height * 0.52,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.03),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: size.width * 0.06),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        "Pelajari Kosa Kata Bahasa Isyarat",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/cube.png',
                                  height: size.height * 0.19,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: size.width * 0.06),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        "Pelajari Kosa Kata Bahasa Isyarat",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/cube.png',
                                  height: size.height * 0.19,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: size.width * 0.06),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        "Pelajari Kosa Kata Bahasa Isyarat",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/cube.png',
                                  height: size.height * 0.19,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: size.width * 0.06),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        "Pelajari Kosa Kata Bahasa Isyarat",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'assets/images/cube.png',
                                  height: size.height * 0.19,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.001,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 145,
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
