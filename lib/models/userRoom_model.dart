class UserRoomModel {
  final String userId;
  final String roomId;
  final DateTime createdAt;

  UserRoomModel({
    required this.userId,
    required this.roomId,
    required this.createdAt,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomId': roomId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}