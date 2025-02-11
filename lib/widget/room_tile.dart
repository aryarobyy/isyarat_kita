import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isyarat_kita/models/chat_model.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/sevices/chat_service.dart';
import 'package:isyarat_kita/sevices/room_service.dart';

class RoomTile extends StatelessWidget {
  final String roomId;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;

  const RoomTile({
    super.key,
    required this.roomId,
    required this.onChatTap,
    required this.onProfileTap,
  });

  String formatLastActive(String lastActive) {
    DateTime dateTime = DateFormat('M/d/yyyy').parse(lastActive);
    final DateFormat formatter = DateFormat('h:mm:ss a z');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoomModel>(
      stream: RoomService().getRoomById(roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("No rooms available"));
        }
        final room = snapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onChatTap,
              child: ListTile(
                leading: InkWell(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: room.image.isNotEmpty
                        ? NetworkImage(room.image)
                        : const AssetImage("assets/images/profile.png")
                    as ImageProvider,
                  ),
                ),
                title: Text(
                  room.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // Display chat information
                subtitle: roomId.isEmpty
                    ? const Text(
                  "No chat yet",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                )
                    : StreamBuilder<List<ChatModel>>(
                  stream: ChatService().getChatByRoomId(roomId),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text(
                        "Loading...",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 16),
                      );
                    }
                    if (chatSnapshot.hasError) {
                      return const Text(
                        "Error loading chat",
                        style: TextStyle(
                            color: Colors.red, fontSize: 16),
                      );
                    }
                    if (!chatSnapshot.hasData ||
                        chatSnapshot.data == null) {
                      return const Text(
                        "No message yet",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 16),
                      );
                    }
                    final List<ChatModel> chats = chatSnapshot.data!;
                    ChatModel latestChat;
                    if (chats.isNotEmpty) {
                      latestChat = chats.last;
                    } else {
                      return const Text(
                        "No message yet",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      );
                    }
                    return Text(
                      latestChat.content ?? "",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}