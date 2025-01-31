import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/firebase_options.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isyarat_kita/pages/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _userInitialize();
  }

  void _userInitialize() async {
    final userId = await _storage.read(key: 'userId');
    if(userId != null){
      setState(() {
        isLoggedIn = true;
      });
    }
    print("UserId: $userId");
  }

  @override
  Widget build(BuildContext context) {
    print("Mainnn: $isLoggedIn");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: isLoggedIn ? DashboardPage() : Authentication(),
      debugShowCheckedModeBanner: false,
    );
  }
}
