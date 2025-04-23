import 'package:flutter/material.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/component/popup.dart';
import 'package:isyarat_kita/component/popup_2.dart';
import 'package:isyarat_kita/component/text.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/pages/profile/profile.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/switch_tile.dart';

part 'account.dart';
part 'notif.dart';
part 'privacy.dart';
part 'support.dart';

class Settings extends StatefulWidget {
  UserModel? userData;
  final int initialTab;
  Settings({super.key, required this.userData, this.initialTab = 0});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _currentIndex = 0;

  @override
  void initState()  {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _widgetOption = [
      Account(userData: widget.userData,),
      Notif(),
      Privacy(),
      Support(),
    ];

    return Scaffold(
      backgroundColor: primaryColor,
      body:  _widgetOption[_currentIndex],
    );
  }
}
