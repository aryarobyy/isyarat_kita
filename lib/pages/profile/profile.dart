import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/text.dart';
import 'package:isyarat_kita/component/text_field_2.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/pages/profile/settings/settings.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:path_provider/path_provider.dart';

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
  void dispose() {
    super.dispose();
  }

  void _handleLogout () async {
    await UserService().signOut();
    MySnackbar(title: "Success", text: "Logout success", type: "success").show(context);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Authentication())
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    final user = widget.userData;
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              // Banner
              Positioned(
                child: user.bannerPic.isEmpty
                    ? Image.asset(
                  "assets/images/bg_profile.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                )
                    : Image(
                  image: FileImage(File(user.bannerPic)),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              // Foto profil
              Positioned(
                top: 40,
                left: (MediaQuery.of(context).size.width - 140) / 2,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: user.profilePic.isEmpty
                      ? AssetImage("assets/images/profile.png")
                      : FileImage(File(user.profilePic)) as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
              ),
              // Tombol edit
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
                        MaterialPageRoute(builder: (context) => UpdateProfile(userData: user)),
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

          // Nama dan bio
          SizedBox(height: 10),
          MyText(
            user.username,
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
          MyText(
            user.bio,
            color: Colors.black,
            fontSize: 18,
          ),
          SizedBox(height: 20),

          // Daftar pengaturan
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _settingData.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade400,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final data = _settingData[index];
              return ListTile(
                leading: Icon(
                  data["icons"],
                  color: secondaryColor,
                ),
                title: MyText(
                  data["content"],
                  color: Colors.black,
                  fontSize: 16,
                ),
                onTap: () {
                  index == 5 ? _handleLogout() :
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => data["tapped"]));
                },
              );
            },
          ),
        ],
      ),
    );
  }


  List<Map<String, dynamic>> get _settingData => [
    {
      "icons": Icons.manage_accounts,
      "content": "Pengaturan Akun",
      "tapped": Settings(userData: widget.userData, initialTab: 0,),
    },
    {
      "icons": Icons.notifications,
      "content": "Notifikasi",
      "tapped": Settings(userData: widget.userData, initialTab: 1),
    },
    {
      "icons": Icons.security,
      "content": "Privasi dan Keamanan",
      "tapped": Settings(userData: widget.userData, initialTab: 2),
    },
    {
      "icons": Icons.language,
      "content": "Bahasa dan Aksesibilitas",
      "tapped": Settings(userData: widget.userData, initialTab: 3),
    },
    {
      "icons": Icons.headset_mic_rounded,
      "content": "Bantuan dan Dukungan",
      "tapped": Settings(userData: widget.userData, initialTab: 4),
    },
    {
      "icons": Icons.output,
      "content": "Log Out",
    }
  ];
}
