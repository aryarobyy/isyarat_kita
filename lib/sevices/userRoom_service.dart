import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:isyarat_kita/models/userRoom_model.dart';
import 'package:isyarat_kita/models/user_model.dart';

final api = dotenv.env['MOBILE_API'];
final url = '$api/user-room';

class UserRoomService {
  // Future<UserRoomModel> postUserRoom(String userId, String roomId) async {
  //   if (url == null) {
  //     throw Exception("API URL is not set in .env");
  //   }
  //   try {
  //     final res = await http.post(
  //       Uri.parse('$url/'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'userId': userId,
  //         'roomId': roomId,
  //       }),
  //     );
  //     if (res.statusCode == 200) {
  //       final Map<String, dynamic> data = jsonDecode(res.body);
  //       if (!data.containsKey('data')) {
  //         throw Exception("Invalid response: missing 'data' field");
  //       }
  //       return UserRoomModel.fromMap(data['data']);
  //     } else {
  //       throw Exception("Failed to post user room, status code: ${res.statusCode}");
  //     }
  //   } catch (e) {
  //     throw Exception("Error posting user room: $e");
  //   }
  // }

  Future<List<UserRoomModel>> getRoomUser(String roomId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }

    final res = await http.get(Uri.parse('$url/room/$roomId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      List<dynamic> data = responseData['data'] ?? [];

      return data.map((item) => UserRoomModel.fromMap(item)).toList();
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch User room: ${res.statusCode}");
    }
  }

  Future<UserRoomModel> getUserRoom(String userId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/user/$userId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      return UserRoomModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch Room user: ${res.statusCode}");
    }
  }
}
