import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/navbar.dart';
import 'package:isyarat_kita/pages/chat/chat.dart';
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
  String? _userId;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    final userId = await _storage.read(key: 'userId');
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("UserIds db:  $_userId");
    final List<Widget> _widgetOptions = [
      const HomePage(),
      const KamusPage(),
      const KameraPage(),
      const ChatPage(),
      SettingPage(userId: _userId ?? ""),
    ];

    return Scaffold(
      body: _widgetOptions[_currentIndex],
      bottomNavigationBar: Navbar(onTapped: _onTapped, currentIndex: _currentIndex),
    );
  }
}
