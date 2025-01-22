import 'package:flutter/material.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/widget/snackbar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Center(
      child: ElevatedButton(
          onPressed: () async{
            await _auth.signOut();
            MySnackbar(title: "Success", text: "Logout success", type: "success").show(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Authentication())
            );
          },
          child: Text("Sign out"),
      ),
    );
  }
}
