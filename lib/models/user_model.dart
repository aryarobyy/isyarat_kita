import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String profilePic;
  final String username;
  final String role;
  final DateTime createdAt;
  final String name;

  UserModel({
    required this.userId,
    required this.email,
    required this.profilePic,
    required this.username,
    required this.role,
    required this.createdAt,
    required this.name
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    if (!data.containsKey('email')) {
      throw ArgumentError('Email is required');
    }

    return UserModel(
      userId: data['id'] ?? "",
      email: data['email'] ?? "",
      profilePic: data['profilePic'] ?? "",
      username: data['username'] ?? "",
      role: data['role'] ?? "",
      name: data['name'] ?? "",
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'profilePic': profilePic,
      'username': username,
      'role': role,
      'name': name,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? profilePic,
    String? username,
    String? role,
    String? name
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt,
      name: name ?? this.name
    );
  }
}
