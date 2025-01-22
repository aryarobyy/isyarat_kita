class UserModel {
  final String userId;
  final String email;
  final String image;
  final String name;
  final String username;

  UserModel({
    required this.userId,
    required this.email,
    required this.image,
    required this.name,
    required this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, documentId) {
    if (!data.containsKey('email')) {
      throw ArgumentError('Email is required');
    }

    return UserModel(
      userId: data['userId'] ?? documentId,
      email: data['email'] ?? "",
      image: data['image'] ?? "",
      name: data['name'] ?? "",
      username: data['username'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'image': image,
      'name': name,
      'username': username,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? image,
    String? name,
    String? username,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      image: image ?? this.image,
      name: name ?? this.name,
      username: username ?? this.username,
    );
  }
}
