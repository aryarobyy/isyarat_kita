class ChatModel {
  final String roomId;
  final String chatId;
  final String senderId;
  final String image;
  final String content;
  final DateTime createdAt;

  ChatModel({
    required this.roomId,
    required this.chatId,
    required this.senderId,
    required this.image,
    required this.content,
    required this.createdAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    final String roomId = data['id'] ?? '';
    final String chatId = data['chatId'] ?? '';
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt = DateTime.parse(data['createdAt']);

    return ChatModel(
      roomId: roomId,
      chatId: chatId,
      senderId: senderId,
      image: image,
      content: content,
      createdAt: createdAt,
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
    };
  }
}
