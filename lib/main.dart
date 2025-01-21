import 'package:flutter/material.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/pages/home.dart';
import 'package:isyarat_kita/pages/launch_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      // ),
      home: DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
