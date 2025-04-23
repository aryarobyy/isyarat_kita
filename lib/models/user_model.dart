enum Role {
  ADMIN,
  USER;

  @override
  String toString() => name;
}


class UserModel {
  final String userId;
  final String email;
  final String profilePic;
  final String bannerPic;
  final String username;
  final String name;
  final String bio;
  final Role role;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.profilePic,
    required this.bannerPic,
    required this.username,
    required this.name,
    required this.bio,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    Role parseRole(String? roleStr) {
      if (roleStr != null) {
        final actualRole = roleStr.contains('.') ? roleStr.split('.').last : roleStr;
        if (actualRole.toUpperCase() == 'ADMIN') return Role.ADMIN;
      }
      return Role.USER;
    }

    return UserModel(
      userId: data['id'] ?? data['userId'] ?? "",
      email: data['email'] ?? "",
      profilePic: data['profilePic'] ?? "",
      bannerPic: data['bannerPic'] ?? "",
      username: data['username'] ?? "",
      name: data['name'] ?? "",
      bio: data['bio'] ?? "",
      role: parseRole(data['role'].toString().split('.').last),
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
      'bannerPic': bannerPic,
      'username': username,
      'name': name,
      'bio': bio,
      'role': role.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? profilePic,
    String? bannerPic,
    String? username,
    String? name,
    String? bio,
    Role? role,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      username: username ?? this.username,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}
