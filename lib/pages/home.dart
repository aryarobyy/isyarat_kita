import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/kamus/kamus.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/banner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  UserModel? userData;
  HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = true;

  List<String> kamus = [
    "assets/images/sibi-logo.png",
    "assets/images/bisindo-logo.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg_db.png',
            fit: BoxFit.cover,
            height: 450,
          ),
          Positioned(
            top: 20,
            left: 25,
            child: _buildHeader(context)
          ),
          Positioned(
            child: _build(context)
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = widget.userData;
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: user.profilePic.isEmpty
                ? AssetImage("assets/images/profile.png")
                : FileImage(File(user.profilePic)) as ImageProvider,
            onBackgroundImageError: (exception, stackTrace) {

            },
          ),
          SizedBox(width: 8,),
          Text(
            user.username,
            style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: whiteColor
          ),
        )
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: MediaQuery.of(context).size.height * 0.8,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      panel: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.0),
            topLeft: Radius.circular(24.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              MyBanner(),
              SizedBox(height: 20,),
              _buildRecentChat(context),
              SizedBox(height: 20,),
              _buildChooseKamus(context),
              SizedBox(height: 20,),
              _buildTrending(context),
              SizedBox(height: 120,),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildRecentChat(BuildContext context){
    return FutureBuilder<List<RoomModel>>(
        future : RoomService().getLatestRoom(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No vocabs available"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Recent Chat",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Text(
                      "Mohon maaf Masih Kosong",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }
          final List<RoomModel> rooms = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Recent Chat",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: room.image.isNotEmpty
                                ? NetworkImage(room.image)
                                : const AssetImage("assets/images/profile.png")
                            as ImageProvider,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
    );
  }

  Widget _buildChooseKamus(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bahasa Isyarat",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SigncodeList(type: "SIBI"))
                );
              },
                child: Image.asset(
                  "assets/images/sibi-logo.png",
                  fit: BoxFit.contain,
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(width: 50,),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SigncodeList(type: "BISINDO"))
                  );
                },
                child: Image.asset(
                  "assets/images/bisindo-logo.png",
                  fit: BoxFit.contain,
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          )
        ),
      ],
    );
  }

  Widget _buildTrending(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "New Trending!",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // Avatar bulat
                      child: Image.asset(
                        "assets/images/banner1.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
