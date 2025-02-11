import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
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
          imageFile: _selectedImage
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
    print("Userid ${widget.userId}");
    return Scaffold(
      appBar: AppBar(title: const Text("Create Room")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: handleUploadImage,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyTextField(
                controller: _titleController,
                name: "Title",
                inputType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              MyButton(
                onPressed: createRoom,
                text: "Create Community",
              ),
            ],
          ),
        ),
      ),
    );
  }

}
