import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/pages/room/chat.dart';
import 'package:isyarat_kita/pages/room/create_room.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/room_tile.dart';

class Community extends StatefulWidget {
  UserModel? userData;

  Community({super.key, required this.userData});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildRoomDisplay(context),
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
              Center(
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "Komunitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateRoom(userId: widget.userData!.userId),
                            ),
                          );
                        },
                        icon: Icon(Icons.person_add_alt_1),
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: FutureBuilder<List<RoomModel>>(
        future: RoomService().getLatestRoom(),
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Mohon maaf, komunitas masih kosong",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }

          final List<RoomModel> rooms = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return RoomTile(
                roomId: room.roomId,
                onChatTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(roomId: room.roomId)));
                },
                onProfileTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
