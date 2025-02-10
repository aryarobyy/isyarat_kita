import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isyarat_kita/models/chat_model.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

final api = dotenv.env['MOBILE_API'];
final url = '$api/room-message';

class ChatService{

  Future<ChatModel> postChat({
    required String senderId,
    required String roomId,
    required String content,
    File? imageFile,
  }) async {
    if (senderId.isEmpty) {
      throw Exception("Sender tidak boleh kosong");
    }
    if (url == null) {
      throw Exception("API URL is not set in .env");
    }
    print("AuthorId in be: $senderId");
    final String uuid = const Uuid().v4();

    try {
      final uri = Uri.parse('$url/post');
      final request = http.MultipartRequest('POST', uri);

      request.fields['chatId'] = uuid;
      request.fields['senderId'] = senderId;
      request.fields['content'] = content;
      request.fields['roomId'] = "roomId";
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
        return ChatModel.fromMap(data['data']);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to create chat: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error create chat: $e");
    }
  }

  Future<ChatModel> updateChat(
      Map<String, dynamic> updatedData,
      String chatId, {
        File? imageFile,
      }) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try{
      final uri = Uri.parse('$url/$chatId');
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
        return ChatModel.fromMap(responseData);
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request: ${response.statusCode} ${response.body}");
      } else {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error updating Room: $e");
    }
  }

  Stream<ChatModel> getChatById(String chatId) async* {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/$chatId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      yield ChatModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  }

  Stream<List<ChatModel>> getChatByRoomId(String roomId) async* {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/$roomId'));
    final Map<String, dynamic> response = jsonDecode(res.body);

    if (res.statusCode == 200) {
      List<dynamic> chatData = response['data'];
      List<ChatModel> chats = chatData.map((chat) => ChatModel.fromMap(chat)).toList();
      yield chats;
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch user: ${res.statusCode}");
    }
  }

  Stream <ChatModel> getChats() async* {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.put(Uri.parse('$url/'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        yield ChatModel.fromMap(data);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch user: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting users: $e");
    }
  }

  Future <void> deleteChat(String chaatId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.delete(Uri.parse('$url/$chaatId'));
      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to delete user: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting users: $e");
    }
  }

}