import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String image;
  final String username;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.image,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    if (!data.containsKey('email')) {
      throw ArgumentError('Email is required');
    }

    return UserModel(
      userId: data['userId'] ?? "",
      email: data['email'] ?? "",
      image: data['image'] ?? "",
      username: data['username'] ?? "",
      role: data['role'] ?? "",
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'image': image,
      'username': username,
      'role': role,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? image,
    String? username,
    String? role,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      image: image ?? this.image,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}
