import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/widget/snackbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _storage = FlutterSecureStorage();
  final AuthService _auth = AuthService();
  String? _userId;

  @override
  void initState() {
    super.initState();
    // _userInitialize();
  }

  Future<String?> getUserId() async {
    final userId = await _storage.read(key: 'userId');
    setState(() {
      _userId = userId;
    });
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40,),
          ElevatedButton(
              onPressed: () async{
                await _auth.signOut();
                MySnackbar(title: "Success", text: "Logout success", type: "success").show(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authentication())
                );
              },
              child: Text("Sign out"),
          ),
          _build(context)
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        future: _storage.read(key: 'userId').then((userId) =>
          userId != null ? _auth.getUserById(userId) : null
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                "Unable to load user information",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          final user = snapshot.data!;
          print("User: ${user.email}");
          return Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Image.asset(
                      "assets/images/bg_profile.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 400,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: (MediaQuery.of(context).size.width - 140) / 2,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: user.image.isEmpty
                              ? AssetImage("assets/images/profile.png")
                              : NetworkImage(user.image),
                          onBackgroundImageError: (exception, stackTrace) {
                            print('Error loading image: $exception');
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: whiteColor
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 160,
                    right: (MediaQuery.of(context).size.width - 280) / 2 + 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: whiteColor,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }
}
