import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/kamus/kamus.dart';
import 'package:isyarat_kita/sevices/blog_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/banner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  final UserModel? userData;

  const HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = true;

  List<String> kamus = [
    "assets/images/sibi-logo.png",
    "assets/images/bisindo-logo.png",
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
            child: _buildHeader(context),
          ),
          Positioned(
            child: _buildSlidingPanel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = widget.userData;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: user.profilePic.isEmpty
                ? const AssetImage("assets/images/profile.png")
                : FileImage(File(user.profilePic)) as ImageProvider,
            onBackgroundImageError: (exception, stackTrace) {},
          ),
          const SizedBox(width: 8),
          Text(
            user.username,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidingPanel(BuildContext context) {
    return SlidingUpPanel(
      minHeight: MediaQuery.of(context).size.height * 0.8,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      panel: Container(
        clipBehavior: Clip.antiAlias,  //biar gak nimpa
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
              const SizedBox(height: 20),
              MyBanner(),
              const SizedBox(height: 20),
              _buildRecentChat(context),
              const SizedBox(height: 20),
              _buildChooseKamus(context),
              const SizedBox(height: 20),
              _buildTrending(context),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentChat(BuildContext context) {
    return FutureBuilder<List<RoomModel>>(
      future: RoomService().getLatestRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Recent Chat",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Text(
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
            const Padding(
              padding: EdgeInsets.all(16.0),
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
                            decoration: const BoxDecoration(
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
      },
    );
  }

  Widget _buildChooseKamus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Bahasa Isyarat",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigncodeList(type: "SIBI"),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/sibi-logo.png",
                fit: BoxFit.contain,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(width: 50),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigncodeList(type: "BISINDO"),
                  ),
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
        ),
      ],
    );
  }

  Widget _buildTrending(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
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
          child: FutureBuilder<List<BlogModel>>(
            future: BlogService().getBlogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Belum ada blog tersedia"));
              }

              final List<BlogModel> blogs = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.956,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                blog.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 40,
                            left: 20,
                            child: SizedBox(
                              width: 220,
                              child: Text(
                                blog.title,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                        ),
                        Positioned(
                            bottom: 20,
                            left: 20,
                            child: SizedBox(
                              width: 220,
                              child: Text(
                                blog.content,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            )
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
