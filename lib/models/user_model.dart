class UserModel {
  final String userId;
  final String email;
  final String profilePic;
  final String username;
  final String name;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.profilePic,
    required this.username,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['id'] ?? data['userId'] ??"",
      email: data['email'] ?? "",
      profilePic: data['profilePic'] ?? "",
      username: data['username'] ?? "",
      name: data['name'] ?? "",
      role: data['role'] ?? "",
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'email': email,
      'profilePic': profilePic,
      'username': username,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? profilePic,
    String? username,
    String? name,
    String? role,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}
