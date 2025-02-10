import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/chat_model.dart';
import 'package:isyarat_kita/sevices/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  const ChatPage({
    super.key,
    required this.roomId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _userId;

  @override
  void initState() {
    _getUserId();
    super.initState();
  }

  Future<void> _getUserId() async {
    final userId = await _storage.read(key: 'userId');
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: _bubbleChat(context)
    );
  }

  Widget _bubbleChat(BuildContext context){
    return StreamBuilder<List<ChatModel>>(
        stream: ChatService().getChatByRoomId(widget.roomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading messages: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No messages yet"));
          }
          final chats = snapshot.data;
          return ListView.builder(
            itemCount: chats!.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              bool isSender = chat.senderId == _userId;
                return BubbleSpecialThree(
                  text: chat.content,
                  color: secondaryColor,
                  isSender: isSender,
                  tail: true,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                );
            }
          );
        }
    );
  }
}