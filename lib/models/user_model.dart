class UserModel {
  final String userId;
  final String email;
  final String profilePic;
  final String bannerPic;
  final String username;
  final String name;
  final String bio;
  final String role;
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
    return UserModel(
      userId: data['id'] ?? data['userId'] ??"",
      email: data['email'] ?? "",
      profilePic: data['profilePic'] ?? "",
      bannerPic: data['bannerPic'] ?? "",
      username: data['username'] ?? "",
      name: data['name'] ?? "",
      bio: data['bio'] ?? "",
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
      'bannerPic': bannerPic,
      'username': username,
      'name': name,
      'bio': bio,
      'role': role,
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
    String? role,
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
