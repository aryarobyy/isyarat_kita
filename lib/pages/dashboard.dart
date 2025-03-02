import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_middleware/flutter_middleware.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/navbar.dart';
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

  @override
  void initState()  {
    super.initState();
    _tokenChecking();
    _currentIndex = widget.initialTab;
    _getCurrentUser();
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
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isLoggedin) {
      return Authentication();
    }

    final widgetOptions = [
      HomePage(userData: _userData,),
      KamusPage(userData: _userData),
      const KameraPage(),
      Community(userData: _userData),
      ProfilePage(userData: _userData),
    ];

    return Scaffold(
      body: widgetOptions[_currentIndex],
      bottomNavigationBar: Navbar(onTapped: _onTapped, currentIndex: _currentIndex),
    );
  }
}