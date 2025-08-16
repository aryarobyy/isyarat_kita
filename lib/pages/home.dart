import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/kamus/kamus.dart';
import 'package:isyarat_kita/sevices/blog_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/util/size_extension.dart';
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
  final PanelController _panelController = PanelController();
  double _panelPosition = 0.0;
  late final Widget _buildSlidingPanelStatic;

  List<String> kamus = [
    "assets/images/sibi-logo.png",
    "assets/images/bisindo-logo.png",
  ];

  @override
  void didChangeDependencies() { //pengganti initState,
    super.didChangeDependencies(); //buat nungguin contextnya siap
    _buildSlidingPanelStatic = _createSlidingPanel();
  }


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
            top: MediaQuery.of(context).padding.top + 1,
            left: 16,
            right: 16,
            child: AnimatedOpacity(
              opacity: _panelPosition < 0.4 ? 1.0 : 0.8, // fade in fade out
              duration: Duration(milliseconds: 150),
              child: _buildHeader(context),
            ),
          ),
          SlidingUpPanel( // pindahin sliding panel kesini
            controller: _panelController,
            minHeight: SizeExtension(context).screenHeight * 0.87,
            maxHeight: SizeExtension(context).screenHeight * 1,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            onPanelSlide: (position) {
              setState(() {
                _panelPosition = position;
              });
            },
            panel: _buildSlidingPanelStatic,
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
    return Row(
      children: [
        CircleAvatar(
          radius: SizeExtension(context).percentHeight(2.8),
          backgroundImage: user.profilePic.isEmpty
              ? const AssetImage("assets/images/profile.png")
              : FileImage(File(user.profilePic)) as ImageProvider,
          onBackgroundImageError: (exception, stackTrace) {},
        ),
        const SizedBox(width: 8),
        Text(
          user.username,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: whiteColor,
          ),
        ),
      ],
    );
  }

  Widget _createSlidingPanel() {
    return Container(
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
                        fontSize: 22,
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
                  fontSize: 22,
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
              fontSize: 22,
            ),
          ),
        ),
        Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          spacing: 20,
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
                width: 80,
                height: 80,
              ),
            ),
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
                width: 80,
                height: 80,
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
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(
          height: SizeExtension(context).screenHeight * 0.2,
          child: FutureBuilder<List<BlogModel>>(
            future: BlogService().getBlogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              final blogs = snapshot.data;
              if (blogs == null || blogs.isEmpty) {
                return const Center(child: Text("Belum ada blog tersedia"));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: blogs.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        Container(
                          width:  SizeExtension(context).screenWidth * 0.4,
                          height:  SizeExtension(context).screenHeight * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              blog.image,
                              fit: BoxFit.cover,
                              width:  SizeExtension(context).screenWidth * 0.4,
                              height:  SizeExtension(context).screenHeight * 0.2,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 36,
                          left: 12,
                          right: 12,
                          child: Text(
                            blog.title,
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Text(
                            blog.content,
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 10,
                            height: 10,
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
