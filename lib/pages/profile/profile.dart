import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/component/text.dart';
import 'package:isyarat_kita/component/text_field_2.dart';
import 'package:isyarat_kita/pages/admin/admin.dart';
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
          SizedBox(height: 10,),
          MyText(
            user.bio.isEmpty ? "Bio" : user.bio,
            color: Colors.black,
            fontSize: 18,
          ),
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
                  if (index == 3) {
                    _showLanguagePopup();
                  } else if (index == 5) {
                    _handleLogout();
                  } else {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => data["tapped"]));
                  }
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
      "tapped": null,
    },
    {
      "icons": Icons.headset_mic_rounded,
      "content": "Bantuan dan Dukungan",
      "tapped": Settings(userData: widget.userData, initialTab: 3),
    },
    {
      "icons": Icons.output,
      "content": "Log Out",
    },
    if (widget.userData?.role == Role.ADMIN)
      {
        "icons": Icons.admin_panel_settings,
        "content": "Admin",
        "tapped": AdminSite(userData: widget.userData!,),
      },
  ];

  void _showLanguagePopup() {
    int selectedLanguage = 0;
    final List<String> languages = [
      'Bahasa Indonesia',
      'Bahasa Inggris',
      'Chineese',
      'Arab',
    ];

    showGeneralDialog(
      context: context,
      barrierDismissible: true, // kalo tap diluar bisa close
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 250),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SlideTransition( //animasi
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              "Bahasa Aplikasi",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ...languages.asMap().entries.map((entry) {
                          int index = entry.key;
                          String language = entry.value;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedLanguage = index;
                              });
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    language,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: selectedLanguage == index ? secondaryColor : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: selectedLanguage != index ? Border.all(color: Colors.white, width: 1.5) : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
