import 'package:isyarat_kita/models/user_model.dart';

class ChatModel {
  final String chatId;
  final String roomId;
  final String senderId;
  final String image;
  final String content;
  final DateTime createdAt;
  final UserModel? sender;

  ChatModel({
    required this.chatId,
    required this.roomId,
    required this.senderId,
    required this.image,
    required this.content,
    required this.createdAt,
    this.sender,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    final String chatId = data['id'] ?? '';
    final String roomId = data['roomId'] ?? '';
    final String senderId = data['senderId'] ?? '';
    final String image = data['image'] ?? '';
    final String content = data['content'] ?? '';
    final DateTime createdAt =  DateTime.tryParse(data['createdAt'] ?? "") ?? DateTime.now();

    final dynamic senderRaw = data["sender"];
    final UserModel? sender = senderRaw is Map<String, dynamic>
        ? UserModel.fromMap(Map<String, dynamic>.from(senderRaw))
        : null;


    return ChatModel(
      roomId: roomId,
      chatId: chatId,
      senderId: senderId,
      image: image,
      content: content,
      createdAt: createdAt,
      sender: sender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': chatId,
      'roomId': roomId,
      'senderId': senderId,
      'image': image,
      'content': content,
      'createdAt': createdAt,
      'sender': sender
    };
  }
}
