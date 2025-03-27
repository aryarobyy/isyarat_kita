import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isyarat_kita/models/chat_model.dart';
import 'package:http/http.dart' as http;

final api = dotenv.env['MOBILE_API'];
final url = '$api/room-message';

class ChatService{

  Future<ChatModel> sendChat({
    required String senderId,
    required String roomId,
    required String content,
    File? imageFile,
  }) async {
    if (senderId.isEmpty) {
      throw Exception("Sender tidak boleh kosong");
    }
    print("AuthorId in be: $senderId");

    try {
      final uri = Uri.parse('$url/');
      final request = http.MultipartRequest('POST', uri);

      request.fields['senderId'] = senderId ?? "";
      request.fields['content'] = content ?? "";
      request.fields['roomId'] = roomId;
      request.fields['createdAt'] = DateTime.now().toIso8601String();

      if (imageFile != null) {
        final multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data == null || !data.containsKey('data') || data['data'] == null) {
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
      throw Exception("Error updating chat: $e");
    }
  }

  Stream<ChatModel> getChatById(String chatId) async* {
    final res = await http.get(Uri.parse('$url/$chatId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      yield ChatModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch chat: ${res.statusCode}");
    }
  }

  Future<List<ChatModel>> getChatByRoomId(String roomId) async {
    final res = await http.get(Uri.parse('$url/$roomId'));
    final Map<String, dynamic> response = jsonDecode(res.body);

    if (res.statusCode == 200) {
      List<dynamic> chatData = response['data'];
      List<ChatModel> chats = chatData.map((chat) => ChatModel.fromMap(chat)).toList();
      return chats;
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch chat: ${res.statusCode}");
    }
  }

  Stream <List<ChatModel>> getChats() async* {
    try {
      final res = await http.put(Uri.parse('$url/'));
      final Map<String, dynamic> response = jsonDecode(res.body);
      if (res.statusCode == 200) {
        List<dynamic> chatsData = response['data'];
        List<ChatModel> chats = chatsData.map((chat) => ChatModel.fromMap(chat)).toList();
        yield chats;
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch chat: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting chats: $e");
    }
  }

  Future <void> deleteChat(String chaatId) async {
    try {
      final res = await http.delete(Uri.parse('$url/$chaatId'));
      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to delete chat: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting chat: $e");
    }
  }

  Future<ChatModel?> getLatestChat(String roomId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/latest/$roomId'));

      if (res.statusCode != 200) {
        throw Exception("HTTP request failed with status: ${res.statusCode}");
      }

      final dynamic decodedResponse = jsonDecode(res.body);
      if (decodedResponse is! Map<String, dynamic>) {
        throw Exception("Invalid chat data format");
      }
      final Map<String, dynamic> responseData = decodedResponse;
      final dynamic data = responseData['data'];

      // Null handler
      if (data == null || (data is Map<String, dynamic> && data.isEmpty)) {
        return null;
      }
      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid chat data format for chat data");
      }
      return ChatModel.fromMap(data);
    } catch (e) {
      throw Exception("Error getting latest chat: $e");
    }
  }


}