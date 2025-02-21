import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:path/path.dart' as path;

class CreateRoom extends StatefulWidget {
  final String userId;
  const CreateRoom({super.key, required this.userId});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  File? _selectedImage;

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

  void createRoom() async {
    final String title = _titleController.text.trim();
    if (title.isEmpty) {
      MySnackbar(title: "warning", text: "Judul tidak boleh kosong", type: "warning").show(context);
    }

      RoomService().createRoom(
          authorId: widget.userId,
          title: title,
          imageFile: _selectedImage,
          description: _descController.text.trim()
      );
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage(initialTab: 3,)
          )
      );
      MySnackbar(title: "Success", text: "Community telah dibuat", type: "success").show(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            MyHeader(title: "Create room"),
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
                      controller: _titleController,
                      name: "Deskripsi",
                      inputType: TextInputType.text,
                      maxLine: 5,
                      minLine: 5,
                      textColor: whiteColor,
                      outlineColor: whiteColor,
                    ),
                    const SizedBox(height: 20),

                    // Create Button
                    MyButton(
                      onPressed: createRoom,
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
}
