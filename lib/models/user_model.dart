class UserModel {
  final String userId;
  final String email;
  final String profilePic;
  final String username;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.profilePic,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['id'] ?? "",
      email: data['email'] ?? "",
      profilePic: data['profilePic'] ?? "",
      username: data['username'] ?? "",
      role: data['role'] ?? "",
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'profilePic': profilePic,
      'username': username,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? profilePic,
    String? username,
    String? role,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}
