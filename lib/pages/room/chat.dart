import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/chat_model.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/sevices/chat_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';

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
  TextEditingController _chatController = TextEditingController();
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

  void _sendChat() async {
    if (_chatController.text.trim().isEmpty) return;
    try{
      final res = await ChatService().sendChat(
          senderId: _userId ?? "",
          roomId: widget.roomId,
          content: _chatController.text.trim()
      );
      print("Sending chat $res");
      _chatController.clear();

    } catch (e){
      print("Cant send chat $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildRoomHeader(context),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(child: _bubbleChat(context)),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
            child: _chatBar(context),
          ),
        ],
      ),
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
            reverse: true,
            itemCount: chats!.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              bool isSender = chat.senderId == _userId;

              bool isLatest(List messages, int index) {
                if (index >= messages.length - 1) return true;
                final currentMsg = messages[index].data() as Map<String, dynamic>;
                final nextMsg = messages[index + 1].data() as Map<String, dynamic>;
                return currentMsg['senderId'] != nextMsg['senderId'];
              }
              bool isNewest(int index) => index == 0;

                return Column(
                  children: [
                    BubbleSpecialThree(
                      text: chat.content,
                      color: secondaryColor,
                      isSender: isSender,
                      tail: isNewest(index),
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ],
                );
            }
          );
        }
    );
  }

  Widget _chatBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: lighterGreen,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 16,
                color: whiteColor,
              ),
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                hintStyle: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixIcon: Icon(
                  Icons.emoji_emotions,
                  color: whiteColor,
                  size: 24,
                ),
                suffixIcon: Icon(
                  Icons.camera_alt,
                  color: whiteColor,
                  size: 24,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: secondaryColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              iconSize: 20,
              onPressed: _sendChat,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomHeader(BuildContext context) {
    return StreamBuilder<RoomModel>(
        stream: RoomService().getRoomById(widget.roomId),
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

          final room = snapshot.data!;
          return Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset("assets/images/back-button.png", width: 60,)
              ),
              SizedBox(width: 5,),
              CircleAvatar(
                backgroundImage: room.image.isNotEmpty == true
                    ? NetworkImage(room.image)
                    : const AssetImage("assets/images/profile.png") as ImageProvider,
                radius: 20,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(room.title),
              Spacer(),
              InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.circle, size: 10, color: secondaryColor,),
                    Icon(Icons.circle, size: 10, color: secondaryColor,),
                    Icon(Icons.circle, size: 10, color: secondaryColor,),
                  ],
                ),
              )
            ],
          );
        }
    );
  }
}