import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/navbar.dart';
import 'package:isyarat_kita/pages/chat.dart';
import 'package:isyarat_kita/pages/home.dart';
import 'package:isyarat_kita/pages/kamera.dart';
import 'package:isyarat_kita/pages/kamus.dart';
import 'package:isyarat_kita/pages/setting.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    KamusPage(),
    KameraPage(),
    ChatPage(),
    SettingPage()
  ];

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      print('Home tapped');
    } else if (index == 1) {
      print('Hand tapped');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: Navbar(onTapped: _onTapped, currentIndex: _currentIndex),
    );
  }
}
