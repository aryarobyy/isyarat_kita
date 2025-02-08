class ChatModel {
  final String roomId;
  final String chatId;
  final String senderId;
  final String image;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ChatModel({
    required this.roomId,
    required this.chatId,
    required this.senderId,
    required this.image,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    final String roomId = data['id'] ?? '';
    final String chatId = data['chatId'] ?? '';
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt = DateTime.now();
    final String updatedAt = data['updatedAt'] ?? '';

    return ChatModel(
      roomId: roomId,
      chatId: chatId,
      senderId: senderId,
      image: image,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'chatId': chatId,
      'senderId': senderId,
      'image': image,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
