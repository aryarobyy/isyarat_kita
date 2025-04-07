import 'package:flutter/material.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/admin/add_blog.dart';
import 'package:isyarat_kita/pages/admin/add_vocab.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/widget/header.dart';

class AdminSite extends StatelessWidget {
  final UserModel? userData;
  const AdminSite({
    super.key,
    this.userData
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(
            title: "Admin Side",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => DashboardPage(initialTab: 4,)
                )
              );
            }
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AddBlog(userData: userData as UserModel,)));
                  },
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 48),
                        SizedBox(height: 8.0),
                        Text(
                          "Tambah Berita",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AddVocab()));
                  },
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 48),
                        SizedBox(height: 8.0),
                        Text(
                          "Tambah Vocab",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
