import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:isyarat_kita/models/user_model.dart';
import 'package:uuid/uuid.dart';

final api = dotenv.env['MOBILE_API'];
final url = '$api/user';
final _storage = FlutterSecureStorage();

bool isEmailValid (String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

Future<UserModel> registerUser(String email, String password) async {
  if (!isEmailValid(email.trim())) {
    throw Exception("Email is not valid");
  }
  if (url == null ){
    throw Exception("url is not set in .env");
  }
  final String uuid = Uuid().v4();
  try{
    await _storage.write(key: 'userId', value: uuid);

    UserModel user = UserModel(
        userId: uuid,
        email: email,
        image: "",
        username: "",
        role: 'user',
        createdAt: DateTime.now()
    );

    final res = await http.post(
      Uri.parse('$url/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': user.userId,
        'email': user.email,
        'password': password,
        'image': user.image,
        'username': user.username,
        'role': user.role,
        'createdAt': user.createdAt.toIso8601String(),
      }),
    );
    if (res.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      return UserModel.fromMap(responseData);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else if (res.statusCode == 409) {
      throw Exception("User already exists");
    } else {
      throw Exception("Failed to register user: ${res.statusCode}");
    }
  } catch (e) {
  throw Exception("Error registering user: $e");
  }
}

Future <UserModel> loginUser(String email, String password) async {
  if (!isEmailValid(email.trim())) {
    throw Exception("Email is not valid");
  }
  if (url == null ){
    throw Exception("url is not set in .env");
  }
  try{
    final res = await http.post(
      Uri.parse('$url/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password
      })
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print('User logged in successfully: $email');
      return data;
    } else {
      throw Exception('Failed to log in: ${res.body}');
    }
  } catch (e) {
    throw Exception("Error registering user: $e");
  }

}

Stream<UserModel> getUserById(String userId) async* {
  if (url == null ){
    throw Exception("url is not set in .env");
  }
  final res = await http.get(Uri.parse('$url/$userId'));

  if (res.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(res.body);
    yield UserModel.fromMap(data);
    } else if (res.statusCode == 400) {
    throw Exception("Invalid request: ${res.body}");
    } else {
    throw Exception("Failed to fetch user: ${res.statusCode}");
  }
}

Future <UserModel> updateUser(Map<String, dynamic> updatedData, String userId) async {
  if (url == null ){
    throw Exception("url is not set in .env");
  }
  try{
    final res = await http.put(
        Uri.parse('$url/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData)
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return UserModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  } catch (e) {
    throw Exception("Error updating user: $e");
  }
}

Future <UserModel> getUsers() async {
  if (url == null ){
    throw Exception("url is not set in .env");
  }
  try{
    final res = await http.put(Uri.parse('$url/'));
    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return UserModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  } catch  (e) {
    throw Exception("Error getting users: $e");
  }
}

Future <void> deleteUser(String userId) async {
  if (url == null ){
    throw Exception("url is not set in .env");
  }
  try{
    final res = await http.delete(Uri.parse('$url/$userId'));
    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to delete user: ${res.statusCode}");
    }
  } catch  (e) {
    throw Exception("Error getting users: $e");
  }
}