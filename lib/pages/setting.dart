import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/popup.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:path/path.dart' as path;

class SettingPage extends StatefulWidget {
  final String userId;
  const SettingPage({
    super.key,
    required this.userId
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late UserModel userStream;

  @override
  void initState() {
    super.initState();
  }

  void changeProfile() async {
    try {
      File? imageFile = await ImageService().pickImage();
      if (imageFile == null) return;
      print("Picked image path: ${imageFile.path}");
      print("Picked image size: ${await imageFile.length()} bytes");

      String fileName = path.basename(imageFile.path);

      if (userStream.email == null || userStream.email!.isEmpty) {
        throw Exception("Email is missing or invalid");
      }

      Map<String, dynamic> userData = {
        "data" : {
          "email": userStream.email,
          "username": userStream.username,
          "profilePic": userStream.profilePic,
          "role": userStream.role,
          "name": userStream.name
        }
      };

      print("Debug - Payload: ${jsonEncode(userData)}");

      await UserService().updateUser(userData, widget.userId, imageFile: imageFile);
      print("Successfully uploaded image");
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
    return StreamBuilder<UserModel>(
        stream: widget.userId != null && widget.userId.isNotEmpty
            ? UserService().getUserById(widget.userId)
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                "Unable to load user information",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          final user = snapshot.data!;
          userStream = user;
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
                              : NetworkImage(user.profilePic),
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
    );
  }
}
