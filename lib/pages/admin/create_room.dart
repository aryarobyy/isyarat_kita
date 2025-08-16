import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/snackbar.dart';


class CreateRoom extends StatefulWidget {
  UserModel? userData;
  CreateRoom({super.key, required this.userData});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  // final TextEditingController _userController = TextEditingController();
  // final TextEditingController _searchController = TextEditingController();
  File? _selectedImage;
  // String _searchQuery = '';
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> handleUploadImage() async {
    try {
      File? imageFile = await ImageService().pickImage();
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  void _createRoom() async {
    final String title = _titleController.text.trim();
    if (title.isEmpty) {
      MySnackbar(title: "warning", text: "Judul tidak boleh kosong", type: "warning").show(context);
    }

      RoomService().createRoom(
          authorId: widget.userData!.userId,
          title: title,
          imageFile: _selectedImage,
          description: _descController.text.trim()
      );
    // final isReady = await RoomService().getRoomByTitle(_titleController.text.trim());
    // if(isReady.isEmpty){
    //   return Center(child: CircularProgressIndicator());
    // }
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage(initialTab: 3,)
          )
      );
      MySnackbar(title: "Success", text: "Community telah dibuat", type: "success").show(context);

  }

  // void _onSearchUser () async {
  //   final String username = _userController.text.trim();
  //   if (username.isEmpty) {
  //     return;
  //   }
  //   if (username == widget.userData!.username) {
  //     MyPopup(title: 'Kamu tidak mencari dirimu sendiri', buttonText: 'Cari Lagi');
  //   }
  //
  //   try{
  //     final res = await UserService().getUserByUsername(username);
  //
  //   } catch (e) {
  //     print("Cant Search user $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            MyHeader(onTap: () {
              Navigator.pop(context);
            },title: "Create room"),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : const AssetImage("assets/images/profile.png")
                          as ImageProvider,
                          radius: 70,
                        ),
                        Positioned(
                          bottom: 3,
                          right: 2,
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: handleUploadImage,
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                    MyTextField(
                      controller: _titleController,
                      name: "Nama Komunitas",
                      inputType: TextInputType.text,
                      textColor: whiteColor,
                      outlineColor: whiteColor,
                    ),

                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _descController,
                      name: "Deskripsi",
                      inputType: TextInputType.text,
                      maxLine: 5,
                      minLine: 5,
                      textColor: whiteColor,
                      outlineColor: whiteColor,
                    ),
                    const SizedBox(height: 40,),
                    MyButton(
                      onPressed: _createRoom,
                      text: "Create",
                      width: 400,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchUser (BuildContext context) {
  //   return FutureBuilder<UserModel>(
  //     future: UserService().getUserByEmail(_searchQuery.toLowerCase()),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //       if (snapshot.hasError) {
  //         return const Center(child: Text("Error loading user profile."));
  //       }
  //       final user = snapshot.data;
  //       if (user == null) {
  //         return const Center(child: Text("No user found."));
  //       }
  //
  //       return UserTile(
  //         user: user,
  //         // onTap: () => handleCreateRoom({'uid': user.uid}),
  //         onTap: () {},
  //       );
  //     },
  //   );
  // }
}