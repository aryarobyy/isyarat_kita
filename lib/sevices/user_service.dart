import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:isyarat_kita/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

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
      final String? bannerPicUrl = userMap['bannerPic'];
      final String? userId = userMap['id'];

      if (userId == null) {
        throw Exception("User id is missing in stored userData");
      }

      Map<String, dynamic> updatedUserData = Map<String, dynamic>.from(userMap);

      if (profilePicUrl != null && profilePicUrl.isNotEmpty &&
          (profilePicUrl.startsWith('http://') || profilePicUrl.startsWith('https://'))) {
        try {
          print("Downloading profile pic from: $profilePicUrl");
          final http.Response response = await http.get(Uri.parse(profilePicUrl));

          if (response.statusCode == 200) {
            final dir = await getApplicationDocumentsDirectory();
            final profileDir = Directory('${dir.path}/Profile');
            if (!await profileDir.exists()) {
              await profileDir.create(recursive: true);
            }

            final originalImage = img.decodeImage(response.bodyBytes);

            if (originalImage != null) {
              final filename = '${profileDir.path}/$userId.png';
              final file = File(filename);

              final pngBytes = img.encodePng(originalImage);
              await file.writeAsBytes(pngBytes);

              if (await file.exists()) {
                updatedUserData['profilePic'] = filename;
                print("Profile picture saved to $filename");
              } else {
                print("Failed to write converted PNG file");
              }
            } else {
              print("Failed to decode the original image");
            }
          } else {
            print("Failed to download profile pic: ${response.statusCode}");
          }
        } catch (e) {
          print("Error during profile image download and conversion: $e");
          print("Stack trace: ${StackTrace.current}");
        }
      }

      if (bannerPicUrl != null && bannerPicUrl.isNotEmpty &&
          (bannerPicUrl.startsWith('http://') || bannerPicUrl.startsWith('https://'))) {
        try {
          print("Downloading profile pic from: $bannerPicUrl");
          final http.Response response = await http.get(Uri.parse(bannerPicUrl));

          if (response.statusCode == 200) {
            final dir = await getApplicationDocumentsDirectory();
            final bannereDir = Directory('${dir.path}/Banner');
            if (!await bannereDir.exists()) {
              await bannereDir.create(recursive: true);
            }

            final originalImage = img.decodeImage(response.bodyBytes);

            if (originalImage != null) {
              final filename = '${bannereDir.path}/$userId.png';
              final file = File(filename);

              final pngBytes = img.encodePng(originalImage);
              await file.writeAsBytes(pngBytes);

              if (await file.exists()) {
                updatedUserData['bannerPic'] = filename;
                print("Profile picture saved to $filename");
              } else {
                print("Failed to write converted PNG file");
              }
            } else {
              print("Failed to decode the original image");
            }
          } else {
            print("Failed to download profile pic: ${response.statusCode}");
          }
        } catch (e) {
          print("Error during profile image download and conversion: $e");
          print("Stack trace: ${StackTrace.current}");
        }
      }
      final UserModel newData = UserModel(
        userId: userId,
        email: updatedUserData['email'] ?? '',
        profilePic: updatedUserData['profilePic'] ?? '',
        bannerPic: updatedUserData['bannerPic'] ?? '',
        username: updatedUserData['username'] ?? '',
        name: updatedUserData['name'] ?? '',
        bio: updatedUserData['bio'] ?? '',
        role: updatedUserData['role'] ?? '',
        createdAt: updatedUserData['createdAt'] != null
            ? DateTime.parse(updatedUserData['createdAt'])
            : DateTime.now(),
      );

      await _storage.write(key: 'userData', value: jsonEncode(newData.toMap()));
    } catch (e) {
      print("Error in savingUser: $e");
      print("Stack trace: ${StackTrace.current}");
    }
  }

  Future<UserModel> getCurrentUser() async {
    final userDataString = await _storage.read(key: 'userData');
    if (userDataString == null) {
      throw Exception("User data undefined");
    }
    final Map<String, dynamic> userMap = jsonDecode(userDataString);
    print("Usermap: $userMap");
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
        File? profileImage,
        File? bannerImage,
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

      if (profileImage != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'newProfilePic',
          profileImage.path,
        );
        request.files.add(multipartFile);
      }

      if (bannerImage != null) {
        final multipartFileBanner = await http.MultipartFile.fromPath(
          'newBannerPic',
          bannerImage.path,
        );
        print("Banner image path: ${bannerImage.path}");
        request.files.add(multipartFileBanner);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response data: $responseData");
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