import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:isyarat_kita/pages/admin/admin.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/blog_service.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/snackbar.dart';

Type getTypeFromString(String typeString) {
  return Type.values.firstWhere(
        (e) => e.toString().split('.').last.toUpperCase() == typeString.toUpperCase(),
    orElse: () => Type.ARTICLE,
  );
}

class AddBlog extends StatefulWidget {
  final UserModel userData;
  const AddBlog({
    super.key,
    required this.userData,
  });

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedType;
  File? _selectedImage;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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

  void _addBlog() async {
    if (_selectedType == null) {
      MySnackbar(
        title: "Error",
        text: "Please select a type",
        type: "failure",
      ).show(context);
      return;
    }
    if (_selectedImage == null) {
      MySnackbar(
        title: "Error",
        text: "Gambar harus ada",
        type: "failure",
      ).show(context);
      return;
    }
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      MySnackbar(
        title: "Error",
        text: "Isi content dan judul harus ada",
        type: "failure",
      ).show(context);
      return;
    }

    final blogType = getTypeFromString(_selectedType!);

    try {
      await BlogService().postBlog(
          authorId: widget.userData.userId,
          authorName: widget.userData.username,
          type: blogType,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          imageFile: _selectedImage
      );

      MySnackbar(
        title: "Success",
        text: "Blog telah ditambahkan",
        type: "success",
      ).show(context);

      setState(() {
        _titleController.clear();
        _contentController.clear();
        _selectedType = null;
        _selectedImage = null;
      });
    } catch (e) {
      print(e);
      MySnackbar(
        title: "Error",
        text: e.toString(),
        type: "failure",
      ).show(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(
            title: "Add Berita",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminSite(),
                ),
              );
            },
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: handleUploadImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey[700]),
                            const SizedBox(height: 8),
                            Text(
                              "Add Image",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MyTextField(
                      controller: _titleController,
                      name: "Title",
                      inputType: TextInputType.text,
                    ),
                    MyTextField(
                      controller: _contentController,
                      name: "Content",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      height: 60,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          onMenuStateChange: (isOpen) {
                            setState(() {
                              _isEnabled = isOpen;
                            });
                          },
                          hint: Text(
                            'Select Type',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          value: _selectedType,
                          items: <String>['ARTICLE', 'NEWS', 'EVENT']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 420,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black26),
                              color: Colors.white,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: IconStyleData(
                            icon: _isEnabled
                                ? const Icon(Icons.arrow_drop_up)
                                : const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            iconEnabledColor: Colors.yellow,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 400, // Same width as button
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            offset: const Offset(0, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility:
                              MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onPressed: _addBlog,
                      text: "Add Vocab",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
