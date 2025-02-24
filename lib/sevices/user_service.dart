import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:isyarat_kita/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final api = dotenv.env['MOBILE_API'];
final url = '$api/user';
final _storage = FlutterSecureStorage();

class UserService {
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> savingUser() async {
    final userDataString = await _storage.read(key: 'userData');

    if (userDataString == null) {
      throw Exception("User data undefined");
    }

    try {
      final Map<String, dynamic> userMap = jsonDecode(userDataString);
      final String? profilePicUrl = userMap['profilePic'];
      final String? userId = userMap['id'];
      if (userId == null) {
        throw Exception("User id is missing in stored userData");
      }
      UserModel? newData;

      if (profilePicUrl != null && profilePicUrl.isNotEmpty && !profilePicUrl.startsWith('/')) {
        try {
          final http.Response response = await http.get(Uri.parse(profilePicUrl));
          final dir = await getTemporaryDirectory();
          final filename = '${dir.path}/Profile${userId}.png';
          final file = File(filename);
          await file.parent.create(recursive: true);
          await file.writeAsBytes(response.bodyBytes);
          newData = UserModel(
            userId: userId,
            email: userMap['email'],
            profilePic: filename,
            bannerPic: userMap['bannerPic'],
            username: userMap['username'],
            name: userMap['name'],
            bio: userMap['bio'],
            role: userMap['role'],
            createdAt: DateTime.parse(userMap['createdAt']),
          );
          print("newData from download: $newData");
        } on PlatformException catch (error) {
          print("Image download error: $error");
        } catch (e) {
          print("Error during image download and saving: $e");
        }
      }

      if (newData == null) {
        newData = UserModel(
          userId: userId,
          email: userMap['email'],
          profilePic: profilePicUrl ?? "",
          bannerPic: userMap['bannerPic'],
          username: userMap['username'],
          name: userMap['name'],
          bio: userMap['bio'],
          role: userMap['role'],
          createdAt: DateTime.parse(userMap['createdAt']),
        );
        print("newData fallback: $newData");
      }

      await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));
    } catch (e) {
      print("Error decoding user data: $e");
    }
  }

  Future<UserModel> getCurrentUser() async {
    final userDataString = await _storage.read(key: 'userData');
    if (userDataString == null) {
      throw Exception("User data undefined");
    }
    final Map<String, dynamic> userMap = jsonDecode(userDataString);
    return UserModel.fromMap(userMap);
  }

  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    if (!isEmailValid(email.trim())) {
      throw Exception("Format email tidak valid");
    }
    if (url == null) {
      throw Exception("API URL is not set in .env"  );
    }

    final String uuid = const Uuid().v4();

    try {
      UserModel user = UserModel(
        userId: uuid,
        email: email,
        profilePic: "",
        bannerPic: "",
        username: username,
        name: "",
        bio: "",
        role: 'USER',
        createdAt: DateTime.now(),
      );

      final res = await http.post(
        Uri.parse('$url/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': user.userId,
          'email': user.email,
          'password': password,
          'image': user.profilePic,
          'username': user.username,
          'name': user.name,
          'role': user.role,
          'createdAt': user.createdAt.toIso8601String(),
        }),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);

        if (!data.containsKey('data')) {
          throw Exception("Invalid response: missing 'data' field");
        }
        await savingUser();
        return UserModel.fromMap(data['data']);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to register user: ${res.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Error registering user: $e");
    }
  }

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    if (!isEmailValid(email.trim())) {
      throw Exception("Format email tidak valid");
    }
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.post(
        Uri.parse('$url/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (!responseData.containsKey('data')) {
          throw Exception("Invalid response: missing 'data' field");
        }
        final userData = responseData['data'];
        if (!userData.containsKey('id')) {
          throw Exception("Invalid response: missing 'userId' field");
        }
        await _storage.write(key: 'userData', value: jsonEncode(userData));
        await _storage.write(key: 'token', value: responseData['token']);

        await savingUser();
        return UserModel.fromMap(userData);
      } else {
        throw Exception('Failed to log in: ${responseData['message'] ?? res.body}');
      }
    } catch (e) {
      throw Exception("Error logging in user: $e");
    }
  }

  Future<UserModel> getUserById(String userId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/$userId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      return UserModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  }

  Future<UserModel> updateUser(
      Map<String, dynamic> updatedData,
      String userId, {
        File? imageFile,
      }) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final uri = Uri.parse('$url/$userId');
      final request = http.MultipartRequest('PUT', uri);

      if (updatedData.containsKey("data") && updatedData["data"] is Map) {
        Map<String, dynamic> dataFields = updatedData["data"];
        dataFields.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      } else {
        updatedData.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      //upload bentuk newPP
      if (imageFile != null) {
        final multipartFile = await http.MultipartFile.fromPath('newProfilePic', imageFile.path);
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserModel.fromMap(responseData);
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request: ${response.statusCode} ${response.body}");
      } else {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }


  Future <List<UserModel>> getUsers() async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/'));
      final Map<String, dynamic> response = jsonDecode(res.body);
      if (res.statusCode == 200) {
        List<dynamic> usersData = response['data'];
        List<UserModel> users = usersData.map((user) => UserModel.fromMap(user)).toList();
        return users;
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch user: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting users: $e");
    }
  }

  Future <void> deleteUser(String userId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.delete(Uri.parse('$url/$userId'));
      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to delete user: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting users: $e");
    }
  }

  Future<void> signOut() async {
    final userData = await getCurrentUser();
    final userId = userData?.userId ?? "";

    final dir = await getTemporaryDirectory();
    final filename = '${dir.path}/Profile${userId}.png';
    final file = File(filename);

    if (await file.exists()) {
      await file.delete();
      print("Image deleted successfully.");
    } else {
      print("Image file not found at $filename");
    }
    await _storage.delete(key: 'userData');
    await _storage.delete(key: 'token');
    // await _auth.signOut();
  }

  Future<List<UserModel>> getUserByUsername(String username) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/username/$username'));
    final Map<String, dynamic> responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      List<dynamic> usersData = responseData['data'];
      List<UserModel> users = usersData.map((user) => UserModel.fromMap(user)).toList();
      return users;
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  }

  Future<UserModel> getUserByEmail(String email) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/email/$email'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      return UserModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  }
}