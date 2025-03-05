import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

final api = dotenv.env['MOBILE_API'];
final url = '$api/room';

class RoomService{

  Future<RoomModel> createRoom({
    required String authorId,
    required String title,
    required String description,
    File? imageFile,
  }) async {
    if (authorId.isEmpty) {
      throw Exception("Author tidak boleh kosong");
    }
    if (url == null) {
      throw Exception("API URL is not set in .env");
    }
    print("AuthorId in be: $authorId,  Title: $title");
    final String uuid = const Uuid().v4();

    try {
      final uri = Uri.parse('$url/post');
      final request = http.MultipartRequest('POST', uri);

      request.fields['roomId'] = uuid;
      request.fields['authorId'] = authorId;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['createdAt'] = DateTime.now().toIso8601String();

      if (imageFile != null) {
        final multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (!data.containsKey('data')) {
          throw Exception("Invalid response: missing 'data' field");
        }
        return RoomModel.fromMap(data['data']);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to create room: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error create room: $e");
    }
  }

  Future<RoomModel> updateRoom(
     Map<String, dynamic> updatedData,
     String roomId, {
      File? imageFile,
     }) async {
   if (url == null) {
    throw Exception("url is not set in .env");
   }
   try{
    final uri = Uri.parse('$url/$roomId');
    final request = http.MultipartRequest('PUT', uri);

    if(updatedData.containsKey('data') && updatedData['data'] is Map){
     Map<String, dynamic> dateFields = updatedData['data'];
     dateFields.forEach((key, value){
      request.fields[key] = value.toString();
     });
    }  else {
     updatedData.forEach((key, value) {
      request.fields[key] = value.toString();
     });
    }

    if (imageFile != null) {
     final multipartFile = await http.MultipartFile.fromPath('newImage', imageFile.path);
     request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
     final responseData = jsonDecode(response.body);
     return RoomModel.fromMap(responseData);
    } else if (response.statusCode == 400) {
     throw Exception("Invalid request: ${response.statusCode} ${response.body}");
    } else {
     throw Exception("Update failed: ${response.body}");
    }
   } catch (e) {
    throw Exception("Error updating Room: $e");
   }
  }

  Future<RoomModel> getRoomById(String roomId) async {
   if (url == null) {
    throw Exception("url is not set in .env");
   }
   final res = await http.get(Uri.parse('$url/$roomId'));

   if (res.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(res.body);
    final data = responseData['data'];
    return RoomModel.fromMap(data);
   } else if (res.statusCode == 400) {
    throw Exception("Invalid request: ${res.body}");
   } else {
    throw Exception("Failed to fetch room: ${res.statusCode}");
   }
  }

  Future <List<RoomModel>> getRooms() async {
   if (url == null) {
    throw Exception("url is not set in .env");
   }
   try {
    final res = await http.get(Uri.parse('$url/'));
    final Map<String, dynamic> response = jsonDecode(res.body);

    if (res.statusCode == 200) {
      List<dynamic> roomsData = response['data'];
      List<RoomModel> rooms = roomsData.map((room) => RoomModel.fromMap(room)).toList();
      return rooms;
    } else if (res.statusCode == 400) {
     throw Exception("Invalid request: ${res.body}");
    } else {
     throw Exception("Failed to fetch room: ${res.statusCode}");
    }
   } catch (e) {
    throw Exception("Error getting room: $e");
   }
  }

  Future <void> deleteRoom(String roomId) async {
   if (url == null) {
    throw Exception("url is not set in .env");
   }
   try {
    final res = await http.delete(Uri.parse('$url/$roomId'));
    if (res.statusCode == 200) {
     return;
    } else {
     throw Exception("Failed to delete room: ${res.statusCode}");
    }
   } catch (e) {
    throw Exception("Error deletting room: $e");
   }
  }

  Future<List<RoomModel>> getLatestRoom()async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/latest'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(res.body);
        List<dynamic> roomsData = response['data'];
        List<RoomModel> rooms = roomsData.map((room) => RoomModel.fromMap(room)).toList();
        return rooms;
      }  else {
        throw Exception("Failed to get latest room: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting room: $e");
    }
  }

  Future<List<RoomModel>> getRoomByTitle(String title)async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/title/$title'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(res.body);
        List<dynamic> roomsData = response['data'];
        List<RoomModel> rooms = roomsData.map((room) => RoomModel.fromMap(room)).toList();
        return rooms;
      }  else {
        throw Exception("Failed to get latest room: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting room: $e");
    }
  }
}