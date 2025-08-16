import 'package:isyarat_kita/models/user_model.dart';

class UserRoomModel {
  final String userId;
  final String roomId;
  final DateTime createdAt;
  final UserModel user;

  UserRoomModel({
    required this.userId,
    required this.roomId,
    required this.createdAt,
    required this.user
  });

  factory UserRoomModel.fromMap(Map<String, dynamic> data) {
    final String userId = data['userId'] ?? '';
    final String roomId = data['roomId'] ?? '';
    final DateTime createdAt = data['createdAt'] != null
        ? DateTime.parse(data['createdAt'])
        : DateTime.now();

    return UserRoomModel(
      userId: userId,
      roomId: roomId,
      createdAt: createdAt,
      user: UserModel.fromMap(data['user'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomId': roomId,
      'createdAt': createdAt.toIso8601String(),
      'user': user.toMap()
    };
  }
}