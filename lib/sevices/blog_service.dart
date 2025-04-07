import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isyarat_kita/models/blog_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

final api = dotenv.env['MOBILE_API'];
final url = '$api/blog';

class BlogService{
  Future<BlogModel> postBlog({
    required String authorId,
    required String authorName,
    required String title,
    required String content,
    required Type type,
    File? imageFile,
  }) async {
    if (url == null) {
      throw Exception("API URL is not set in .env");
    }

    try {
      final uri = Uri.parse('$url/');
      final request = http.MultipartRequest('POST', uri);

      request.fields['authorId'] = authorId;
      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['createdBy'] = authorName;
      request.fields['type'] = type.toString().split('.').last;

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
        return BlogModel.fromMap(data['data']);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to create blog: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error create blog: $e");
    }
  }

  Future<BlogModel> updateBlog(
      Map<String, dynamic> updatedData,
      String blogId, {
        File? imageFile,
      }) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try{
      final uri = Uri.parse('$url/$blogId');
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
        return BlogModel.fromMap(responseData);
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request: ${response.statusCode} ${response.body}");
      } else {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error updating Blog: $e");
    }
  }

  Stream<BlogModel> getBlogById(String blogId) async* {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    final res = await http.get(Uri.parse('$url/$blogId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final data = responseData['data'];
      yield BlogModel.fromMap(data);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to fetch blog: ${res.statusCode}");
    }
  }

  Future <List<BlogModel>> getBlogs() async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.get(Uri.parse('$url/'));
      final Map<String, dynamic> response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<dynamic> data = response['data'];
        print(data);
        List<BlogModel> blogs = data.map((blog) => BlogModel.fromMap(blog)).toList();
        print(blogs);
        return blogs;
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch blog: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting blogs: $e");
    }
  }

  Future<List<BlogModel>> getLatestBlogs({int limit = 2}) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final Uri uri = Uri.parse('$url/latest?limit=$limit');

      final res = await http.get(uri);
      final Map<String, dynamic> response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        List<dynamic> data = response['data'];
        List<BlogModel> blogs = data.map((blog) => BlogModel.fromMap(blog)).toList();
        return blogs;
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch blogs: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting blogs: $e");
    }
  }

  Future <void> deleteBlog(String blogId) async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.delete(Uri.parse('$url/$blogId'));
      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to delete blog: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting blog: $e");
    }
  }

}