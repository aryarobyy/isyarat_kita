import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/pages/room/chat.dart';
import 'package:isyarat_kita/pages/room/create_room.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/room_tile.dart';

class Community extends StatefulWidget {
  final String userId;
  const Community({super.key, required this.userId});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                _buildRoomDisplay(context),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateRoom(userId: widget.userId),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/back-button.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Komunitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      "Semua",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // TODO: aksi ketika tab "Belum Dibaca" ditekan
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Belum Dibaca",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildRoomDisplay(BuildContext context) {
    return StreamBuilder<List<RoomModel>>(
      stream: RoomService().getRooms(),
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
        final List<RoomModel> rooms = snapshot.data!;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: rooms.length,
          itemBuilder: (context, index){
            final room = rooms[index];
              return RoomTile(
                roomId: room.roomId,
                onChatTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(roomId: room.roomId)
                      )
                  );
                },
                onProfileTap: () {},
              );
          },
        );
      },
    );
  }
}
