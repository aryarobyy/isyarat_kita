import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:http/http.dart' as http;

final _storage = FlutterSecureStorage();

class MyMiddleware {
  Future<bool>verifyToken (String token) async {
    try {
      if (url == null) {
        throw Exception("url is not set in .env");
      }

      final res = await http.post(Uri.parse('$url/verify-token'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({token})
      );
      if(res.statusCode == 200){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> check() async {
    final token = await _storage.read(key: 'token');
    if(token == null || token == "undefined") {
      return false;
    }
    await verifyToken(token);
    return true;
  }
}