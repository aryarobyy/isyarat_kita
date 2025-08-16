import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/models/vocab_model.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/vocab_service.dart';

part 'signcode_list.dart';

class KamusPage extends StatelessWidget {
  UserModel? userData;
  KamusPage({super.key, required this.userData});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      color: primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                "Kamus Bahasa Isyarat",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                ),
              ),
            ),
            SizedBox(height: 30,),
            Expanded(
              child: _build(context)
            )
          ],
        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/sibi-logo.png",
                            width: 80,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "(Sistem Isyarat Bahasa Indonesia) adalah sistem bahasa isyarat yang dikembangkan untuk komunikasi dengan penyandang tunarungu di Indonesia. ",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(320, 40),
                        backgroundColor: primaryColor
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SigncodeList(type: "SIBI")),
                        );
                      },
                      child: Text(
                        "Selengkapnya",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Divider(
                  color: primaryColor,
                  thickness: 3,
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Image.asset(
                              "assets/images/bisindo-logo.png",
                              width: 80,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "(Bahasa Isyarat Indonesia) adalah bahasa isyarat yang berkembang secara alami di komunitas tunarungu Indonesia.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(320, 40),
                        backgroundColor: primaryColor
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SigncodeList(type: "BISINDO",)),
                        );
                      },
                      child: Text(
                        "Selengkapnya",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }
}
