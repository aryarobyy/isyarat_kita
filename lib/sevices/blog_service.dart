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
    required String author,
    required String title,
  }) async {
    if(author.isEmpty){
      throw Exception("Author tidak boleh kosong");
    }
    if (url == null) {
      throw Exception("API URL is not set in .env"  );
    }
    final String uuid = const Uuid().v4();
    BlogModel blog = BlogModel(
      blogId: uuid,
      image: "",
      author: author,
      title: title,
      content: "",
      type: "",
      createdAt: DateTime.now(),
    );
    final res = await http.post(
      Uri.parse('$url/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'blogId': blog.blogId,
        'image': blog.image,
        'author': blog.author,
        'title': blog.title,
        'type': blog.type,
        'content': blog.content,
        'createdAt': blog.createdAt.toIso8601String(),
      }),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);

      if (!data.containsKey('data')) {
        throw Exception("Invalid response: missing 'data' field");
      }

      return BlogModel.fromMap(data['data']);
    } else if (res.statusCode == 400) {
      throw Exception("Invalid request: ${res.body}");
    } else {
      throw Exception("Failed to create blog: ${res.statusCode}");
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

  Future <BlogModel> getBlogs() async {
    if (url == null) {
      throw Exception("url is not set in .env");
    }
    try {
      final res = await http.put(Uri.parse('$url/'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        return BlogModel.fromMap(data);
      } else if (res.statusCode == 400) {
        throw Exception("Invalid request: ${res.body}");
      } else {
        throw Exception("Failed to fetch blog: ${res.statusCode}");
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