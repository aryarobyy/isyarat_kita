class ChatModel {
  final String chatId;
  final String roomId;
  final String senderId;
  final String image;
  final String content;
  final DateTime createdAt;

  ChatModel({
    required this.chatId,
    required this.roomId,
    required this.senderId,
    required this.image,
    required this.content,
    required this.createdAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    final String chatId = data['id'] ?? '';
    final String roomId = data['roomId'] ?? '';
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt =  DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();

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
