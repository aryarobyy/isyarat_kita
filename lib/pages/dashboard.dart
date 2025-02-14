import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/navbar.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/community.dart';
import 'package:isyarat_kita/pages/home.dart';
import 'package:isyarat_kita/pages/kamera.dart';
import 'package:isyarat_kita/pages/kamus.dart';
import 'package:isyarat_kita/pages/setting.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:path_provider/path_provider.dart';

class DashboardPage extends StatefulWidget {
  final int initialTab;
  const DashboardPage({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  UserModel? _userData;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _getCurrentUser();
  }

  Future<UserModel?> _getCurrentUser() async {
    final userData = await UserService().getCurrentUser();
    if (mounted) {
      setState(() {
        _userData = userData;
      });
    }
    return userData;
  }


  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
      final List<Widget> _widgetOptions = [
        const HomePage(),
        const KamusPage(),
        const KameraPage(),
        Community(userData: _userData,),
        SettingPage(userData: _userData),
      ];

      return Scaffold(
        body: _widgetOptions[_currentIndex],
        bottomNavigationBar: Navbar(onTapped: _onTapped, currentIndex: _currentIndex),
      );
    }

}
