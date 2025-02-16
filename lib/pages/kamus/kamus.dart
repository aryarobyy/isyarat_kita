import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/models/vocab_model.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/sevices/vocab_service.dart';
import 'package:isyarat_kita/widget/snackbar.dart';

part 'signcode_list.dart';
part 'add_kamus.dart';

class KamusPage extends StatelessWidget {
  UserModel? userData;
  KamusPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final role = userData?.role;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Kamus Bahasa Isyarat")),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Image.asset("assets/images/sibi-logo.png"),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "(Sistem Isyarat Bahasa Indonesia) adalah sistem bahasa isyarat yang dikembangkan untuk komunikasi dengan penyandang tunarungu di Indonesia. ",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
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
                      minimumSize: Size(380, 60),
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
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Divider(
                color: secondaryColor,
                thickness: 8,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Image.asset("assets/images/bisindo-logo.png"),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "(Bahasa Isyarat Indonesia) adalah bahasa isyarat yang berkembang secara alami di komunitas tunarungu Indonesia.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
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
                      minimumSize: Size(380, 60),
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
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          role == 'ADMIN' ? Positioned( //must admin to upload vocab
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddKamus(),
                  ),
                );
              },
              child: Icon(
                color: secondaryColor,
                Icons.add,
                size: 40,
              ),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
