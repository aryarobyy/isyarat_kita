import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

final api = dotenv.env['MOBILE_API'];
final url = '$api/user';

class ImageService{
  final ImagePicker _picker = ImagePicker();

  Future <File?> pickImage() async{
    try{
      XFile? pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70
      );
      if (pickedImage == null) {
        throw Exception("Gambar tidak boleh kosong");
      }

      File imageFile = File(pickedImage.path);
      if(!await imageFile.exists()){
        throw Exception("File tidak ditemukan");
      }

      final uuid = Uuid().v4();
      final String extension = path.extension(pickedImage.path);
      final String newFileName = '$uuid$extension';
      final Directory tempDir = await getTemporaryDirectory();
      final String newPath = path.join(tempDir.path, newFileName);
      final File newImageFile = await imageFile.copy(newPath);

      return newImageFile;
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  String generateSignature(String publicId, int timestamp, String apiSecret) {
    final params = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final bytes = utf8.encode(params);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}