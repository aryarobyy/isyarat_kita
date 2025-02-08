import 'package:flutter/material.dart';
import 'package:isyarat_kita/pages/room/create_room.dart';

class Community extends StatefulWidget {
  final String userId;
  const Community({super.key, required this.userId});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    print("UserId: ${widget.userId}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Community"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              bottom: 15,
              right: 15,
                child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateRoom(userId: widget.userId)
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      size: 40,
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
