import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/middleware/user_middleware.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/pages/community/community.dart';
import 'package:isyarat_kita/pages/home.dart';
import 'package:isyarat_kita/pages/kamera.dart';
import 'package:isyarat_kita/pages/kamus/kamus.dart';
import 'package:isyarat_kita/pages/profile/profile.dart';
import 'package:isyarat_kita/sevices/user_service.dart';

class DashboardPage extends StatefulWidget {
  final int initialTab;
  const DashboardPage({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  late UserModel _userData;
  final _storage = FlutterSecureStorage();
  bool isLoggedin = false;
  bool _isLoading = true;

  late UserModel _dummyUser = userData;
  UserModel userData = UserModel( // dummy data
    userId: "3b052129-f4c1-46fb-81cc-e68e2923c187",
    email: "ilhamgod14@gmaill.com",
    profilePic: "",
    bannerPic: "",
    username: "ilhamgodddd",
    name: "",
    bio: "My name bio",
    role: Role.ADMIN,
    createdAt: DateTime(2024, 1, 1),
  );
  
  @override
  void initState()  {
    super.initState();
    // _tokenChecking();
    _currentIndex = widget.initialTab;
    // _getCurrentUser();
  }

  Future<bool> _tokenChecking() async {
    try {
      final token = await _storage.read(key: "token") ?? "";
      MyMiddleware middleware = MyMiddleware();

      final response = await middleware.verifyToken(token);
      if(response == false){
        await UserService().signOut();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Authentication())
        );
      }
      return response;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final token = await _storage.read(key: "token") ?? "";
      if (token.isEmpty) {
        if (mounted) {
          setState(() {
            isLoggedin = false;
            _isLoading = false;
          });
        }
        return;
      }
      final userData = await UserService().getCurrentUserLocal();
      if (mounted) {
        setState(() {
          isLoggedin = userData != null;
          if (isLoggedin) {
            _userData = userData;
          }
          _isLoading = false;
        });
      }
    } catch(e) {
      print(e);
    }
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return Scaffold(
    //     body: CircularProgressIndicator(),
    //   );
    // }
    //
    // if (!isLoggedin) {
    //   return Authentication();
    // }

    final widgetOptions = [
      HomePage(userData: _userData,),
      KamusPage(userData: _userData),
      const KameraPage(),
      Community(userData: _userData),
      ProfilePage(userData: _userData),
    ];

    final _getIconName = [
      ImageIcon(AssetImage('assets/icons/home.png'), size: 40,color: Colors.white),
      ImageIcon(AssetImage('assets/icons/hand.png'), size: 40,color: Colors.white),
      ImageIcon(AssetImage('assets/icons/mid.png'),size: 45,color: Colors.white),
      ImageIcon(AssetImage('assets/icons/msg.png'),size: 40,color: Colors.white),
      ImageIcon(AssetImage('assets/icons/setting.png'),size: 40,color: Colors.white,),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: widgetOptions[_currentIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -8,
            child: CurvedNavigationBar(
              items: _getIconName,
              onTap: _onTapped,
              color: primaryColor,
              index: _currentIndex,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: secondaryColor,
            )
          ),
        ],
      ),
    );

  }
}