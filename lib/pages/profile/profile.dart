import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/text.dart';
import 'package:isyarat_kita/component/text_field_2.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'setting.dart';
part 'update_profile.dart';

class ProfilePage extends StatefulWidget {
  UserModel? userData;
  ProfilePage({
    super.key,
    required this.userData
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40,),
          ElevatedButton(
              onPressed: () async{
                // await _auth.signOut();
                MySnackbar(title: "Success", text: "Logout success", type: "success").show(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authentication())
                );
              },
              child: Text("Sign out"),
          ),
          _build(context)
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    final user = widget.userData;
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }
    print("Banner: ${user.profilePic}");

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              child: user.bannerPic.isEmpty
                  ? Image.asset(
                "assets/images/bg_profile.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              )
                  : Image(
                image: FileImage(File(user.bannerPic)) as ImageProvider,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            Positioned(
              top: 40,
              left: (MediaQuery.of(context).size.width - 140) / 2,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.profilePic.isEmpty
                        ? AssetImage("assets/images/profile.png")
                        : FileImage(File(user.profilePic)) as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {

                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 120,
              right: (MediaQuery.of(context).size.width - 280) / 2 + 80,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateProfile(userData: user,))
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: whiteColor,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
