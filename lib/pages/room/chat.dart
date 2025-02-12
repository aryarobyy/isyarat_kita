import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/chat_model.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/sevices/chat_service.dart';
import 'package:isyarat_kita/sevices/chat_socket.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  final ScrollController _scrollController = ScrollController();
  String? _userId;
  List<ChatModel> _chats = [];
  late final IO.Socket _socket;

  @override
  void initState() {
    _getUserId();
    _socket = ChatSocket().socket;
    _socketInitialize();
    _scrollController.addListener(() {});
    super.initState();
  }

  void dispose(){
    _chatController.dispose();
    _socket.disconnect();
    // _socket.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _socketInitialize () {
    if (!_socket.connected) {
      _socket.connect();
    };

    try{
      _socket.onConnect((_) {
        _socket.emit("joinRoom", widget.roomId);
      });
      _socket.on('loadMessages', (data) {
        setState(() {
          _chats = (data as List).map((json) => ChatModel.fromMap(json)).toList();
          _chats.sort((a, b) => b.createdAt.compareTo(a.createdAt)); //cari chat terbaru
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      });
      _socket.onDisconnect((_)  {
        _socket.connect();
      });
      // _socket.on('fromServer', (data) {
      //   setState(() {
      //     _chats.insert(0, ChatModel.fromMap(data));
      //     _chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      //   });
      //   WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      // });
    } catch (e) {
      print("Cant send chat: $e");
    }

  }

  Future<void> _getUserId() async {
    final userId = await _storage.read(key: 'userId');
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  void _sendChat() {
    if(_chatController.text.trim().isEmpty) return;
    _socket.emit(
      'sendMessage', {
       "senderId" :_userId,
       "roomId": widget.roomId,
       "content": _chatController.text.trim(),
      });
    _chatController.clear();
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

  Widget _bubbleChat(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _chats.length,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final isSender = chat.senderId == _userId;
        bool isNewest(int index) => index == 0;

        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: BubbleSpecialThree(
            text: chat.content,
            color: isSender ? primaryColor : secondaryColor,
            tail: isNewest(index),
            isSender: isSender,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      },
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
                onTap: () {
                  Navigator.pop(context);
                  super.dispose();
                  },
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