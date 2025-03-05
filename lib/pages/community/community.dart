import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/searchbar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:isyarat_kita/models/chat_model.dart';
import 'package:isyarat_kita/sevices/chat_socket.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:isyarat_kita/component/button.dart';
import 'package:isyarat_kita/component/text_field.dart';
import 'package:isyarat_kita/pages/dashboard.dart';
import 'package:isyarat_kita/sevices/images_service.dart';
import 'package:isyarat_kita/widget/header.dart';
import 'package:isyarat_kita/widget/snackbar.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/models/room_model.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:isyarat_kita/sevices/room_service.dart';
import 'package:isyarat_kita/widget/room_tile.dart';


part 'chat.dart';
part 'create_room.dart';
part 'community_detail.dart';

class Community extends StatefulWidget {
  UserModel? userData;

  Community({super.key, required this.userData});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 20, left: 10),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: _searchQuery.isEmpty ?
                _buildRoomDisplay(context) : _buildSearchRoom(context)
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
                                CreateRoom(
                                  userData: widget.userData,
                                ),
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
              Column(
                children: [
                  MySearchBar(
                    controller: _searchController,
                    hintText: "Cari Komunitas",
                    onPressed: () {
                      setState(() {
                        _searchQuery = _searchController.text;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomDisplay(BuildContext context) {
    return FutureBuilder<List<RoomModel>>(
      future: RoomService().getLatestRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
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
    );
  }

  Widget _buildSearchRoom(BuildContext context) {
    if(_searchQuery.isEmpty){
      return _buildRoomDisplay(context);
    }

    return FutureBuilder<List<RoomModel>>(
      future: RoomService().getRoomByTitle(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading komunitas."));
        }
        final rooms = snapshot.data;
        if (rooms == null || rooms.isEmpty) {
          return const Center(child: Text("Komunitas belum tersedia"));
        }
        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return RoomTile(
              roomId: room.roomId,
              onChatTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatPage(roomId: room.roomId)));
              },
              onProfileTap: () {
              },
            );
          },
        );
      },
    );
  }
}
