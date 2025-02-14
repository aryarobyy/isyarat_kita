import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/popup.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  UserModel? userData;
  SettingPage({
    super.key,
    required this.userData
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  void changeProfile() async {
    final user = widget.userData!;
    try {
      File? imageFile = await ImageService().pickImage();
      if (imageFile == null) return;
      print("Picked image path: ${imageFile.path}");
      print("Picked image size: ${await imageFile.length()} bytes");

      String fileName = path.basename(imageFile.path);

      if (user.email == null || user.email!.isEmpty) {
        throw Exception("Email is missing or invalid");
      }

      Map<String, dynamic> userData = {
        "data" : {
          "email": user.email,
          "username": user.username,
          "profilePic": user.profilePic,
          "role": user.role,
        }
      };

      await UserService().updateUser(userData, widget.userData!.userId, imageFile: imageFile);
      final dir = await getTemporaryDirectory();
      final newFileName = '${dir.path}/Profile${user.userId}.png';

      UserModel newData = UserModel(
          userId: user.userId,
          email: user.email,
          profilePic: newFileName,
          username: user.username,
          role: user.role,
          createdAt: user.createdAt,
      );

      await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));
    } catch (e) {
      print("Error uploading image: $e");
    }
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
                Navigator.push(context,
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
    final user = widget.userData!;
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              child: Image.asset(
                "assets/images/bg_profile.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 400,
              ),
            ),
            Positioned(
              top: 60,
              left: (MediaQuery.of(context).size.width - 140) / 2,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: user.profilePic.isEmpty
                        ? AssetImage("assets/images/profile.png")
                        : FileImage(File(user.profilePic)) as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {

                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: whiteColor
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 160,
              right: (MediaQuery.of(context).size.width - 280) / 2 + 60,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: changeProfile,
                  icon: Icon(
                    Icons.edit,
                    color: whiteColor,
                    size: 26,
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
