import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:isyarat_kita/models/vocab_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

final api = dotenv.env['MOBILE_API'];
final url = '$api/vocab';

class VocabService{

  Future<VocabModel> addVocab({
    required String name,
    required String signCode,
    File? imageFile,
  }) async {
    if (url == null) {
      throw Exception("API URL is not set in .env");
    }
    final String uuid = const Uuid().v4();

    try {
      final uri = Uri.parse('$url/');
      final request = http.MultipartRequest('POST', uri);

      request.fields['vocabId'] = uuid;
      request.fields['name'] = name;
      request.fields['signCode'] = signCode;

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
        return VocabModel.fromMap(data['data']);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to create vocab: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error create vocab: $e");
    }
  }

  Future<VocabModel> updateVocab(
      Map<String, dynamic> updatedData,
      String vocabId, {
        File? imageFile,
      }) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try{
      final uri = Uri.parse('$url/$vocabId');
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
        return VocabModel.fromMap(responseData);
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request: ${response.statusCode} ${response.body}");
      } else {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error updating vocab: $e");
    }
  }

  Future<List<VocabModel>> getVocabByType(String type) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/signCode/$type'));
      final Map<String, dynamic> response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<dynamic> data = response['data'];
        print("Datas: $data");
        List<VocabModel> vocabs = data.map((room) => VocabModel.fromMap(room)).toList();
        print("Vocabs: $vocabs");
        return vocabs;
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch vocab: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting vocabs: $e");
    }
  }

  Future<VocabModel> getVocabById(String vocabId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/$vocabId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      return VocabModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch vocab: ${res.statusCode}");
    }
  }

  Future<VocabModel> getVocabs() async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        return VocabModel.fromMap(data);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch vocab: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting vocabs: $e");
    }
  }

  Future <void> deleteVocab(String vocabId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.delete(Uri.parse('$url/$vocabId'));
      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to delete vocab: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting vocab: $e");
    }
  }

}