part of 'community.dart';

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
  TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatModel> _chats = [];
  late final IO.Socket _socket;
  UserModel? _currentUser;
  List<UserRoomModel>? _members;

  final Map<String, UserModel> _userCache = {}; //User data save here to make it not get call in future

  @override
  void initState() {
    _getCurrentUser();
    getMembers();
    _socket = ChatSocket().socket;
    _socketInitialize();
    _scrollController.addListener(() {});

    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: (ReceivedAction receivedAction) async {
    //     if (receivedAction.payload != null) {
    //       final roomId = receivedAction.payload?['roomId'];
    //       if (roomId != null && context.mounted) {
    //         Navigator.of(context).push(MaterialPageRoute(
    //           builder: (context) => ChatPage(
    //             roomId: roomId,
    //           ),
    //         ));
    //       }
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    _socket.off('loadMessages');
    _socket.off('newMessage');
    _socket.off('disconnect');

    _chatController.dispose();
    _socket.disconnect();
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

  void _socketInitialize() async {
    if (!_socket.connected) {
      _socket.connect();
    }

    try {
      _socket.onConnect((_) {
        print('Socket connected! Status: ${_socket.connected}');
        _socket.emit("joinRoom", widget.roomId);
      });

      _socket.on('loadMessages', (data) {
        if (!mounted) return;

        setState(() {
          final List<dynamic> nestedList = data as List;
          final List<dynamic> messagesList =
          nestedList.isNotEmpty && nestedList.first is List
              ? nestedList.first as List<dynamic>
              : nestedList;

          _chats = messagesList.map((element) {
            if (element is Map) {
              return ChatModel.fromMap(Map<String, dynamic>.from(element));
            } else {
              print("Warning: Expected a Map but found: $element");
              return null;
            }
          }).whereType<ChatModel>().toList();
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollToBottom();
        });
      });

      _socket.on('newMessage', (data) {
        if (!mounted) return;
        if (data == null || (data is Map && data.isEmpty)) {
          print("Empty message data received, triggering reload.");
          _socket.emit("joinRoom", widget.roomId);
          return;
        }
          setState(() {
            _chats.insert(0, ChatModel.fromMap(data[0]));
          });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollToBottom();
        });
      });

      _socket.onDisconnect((_) {
        if (!mounted) return;
        _socket.connect();
      });
    } catch (e) {
      print("Can't see chat: $e");
    }
  }

  Future<UserModel?> _getCurrentUser() async {
    final userData = await UserService().getCurrentUserLocal();
    if (mounted) {
      setState(() {
        _currentUser = userData;
      });
    }
    return userData;
  }

  void _sendChat() async {
    final trimmedText = _chatController.text.trim();
    if (trimmedText.isEmpty) return;

    final messageData = {
      "senderId": _currentUser?.userId,
      "roomId": widget.roomId,
      "content": trimmedText,
    };

    _socket.emit('sendMessage', messageData);

    // final List<UserRoomModel> otherMembers = (_members?.where((id) => id != _currentUser).toList()) ?? [];
    // if (otherMembers.isNotEmpty) {
    //   await NotifService.showNotification(
    //     receiverIds: otherMembers,
    //     title: "New Message from ${_currentUser.username}",
    //     message: trimmedText,
    //     roomId: widget.roomId ?? '',
    //   );
    //   print("Notification send");
    // }
    _chatController.clear();

    //
    // await AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
    //     channelKey: 'Community_channel',
    //     title: 'sdssa',
    //     body: "sdassad",
    //     notificationLayout: NotificationLayout.Default,
    //     payload: messageData,
    //   )
    // );

    // Future.delayed(Duration(milliseconds: 300), () {
    //   _socket.emit("joinRoom", widget.roomId);
    // });
  }

  Future<List<UserModel>> getMembers() async {
    try {
      List<UserRoomModel> roomUsers = await UserRoomService().getRoomUser(widget.roomId);
      setState(() {
        _members = roomUsers;
      });
      return roomUsers.map((roomUser) => roomUser.user).toList();
    } catch (e) {
      throw Exception("Failed to get members: $e");
    }
  }

  Future <void> attachClick() async {
    try{

    } catch (e) {
      throw Exception("Failed attach");
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

  Widget _bubbleChat(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _chats.length,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final isSender = chat.senderId == _currentUser?.userId;
        // bool isNewest(int index) => index == 0;

        final bool showAvatar = (index == _chats.length - 1)
            || (_chats[index + 1].senderId != chat.senderId);

        //cek data user daah ada belum di userCache
        if (_userCache.containsKey(chat.senderId)) {
          final sender = _userCache[chat.senderId]!;
          return _buildChatItemWithSender(chat, sender, isSender, showAvatar);
        }

        return StreamBuilder<UserModel>(
          stream: UserService().streamUserById(chat.senderId),
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

            final sender = snapshot.data!;
            _userCache[chat.senderId] = sender;

            return _buildChatItemWithSender(chat, sender, isSender, showAvatar);
          },
        );
      },
    );
  }

  Widget _buildChatItemWithSender(
      ChatModel chat, UserModel sender, bool isSender, bool showAvatar) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            Align(
              alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: isSender
                    ? [
                  Text(
                    sender.username,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage: sender.profilePic.isNotEmpty
                        ? NetworkImage(sender.profilePic)
                        : const AssetImage("assets/images/profile.png")
                    as ImageProvider,
                    radius: 12,
                  ),
                ]
                    : [
                  CircleAvatar(
                    backgroundImage: sender.profilePic.isNotEmpty
                        ? NetworkImage(sender.profilePic)
                        : const AssetImage("assets/images/profile.png")
                    as ImageProvider,
                    radius: 12,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sender.username,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          BubbleSpecialThree(
            text: chat.content,
            color: isSender ? primaryColor : secondaryColor,
            tail: isSender,
            isSender: isSender,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
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
                suffixIcon: IconButton(
                  onPressed: attachClick,
                  icon: Icon(
                    Icons.attach_file,
                    size: 24,
                  ),
                  color: whiteColor,
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
    return FutureBuilder<RoomModel>(
        future: RoomService().getRoomById(widget.roomId),
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
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => CommunityDetail(roomData: room,),
              )
              );
            },
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(initialTab: 3,)));
                    },
                    child: Image.asset("assets/images/back-button.png", width:30,)
                ),
                SizedBox(width: 30,),
                CircleAvatar(
                  backgroundImage: room.image.isNotEmpty == true
                      ? NetworkImage(room.image)
                      : const AssetImage("assets/images/profile.png") as ImageProvider,
                  radius: 15,
                ),
                const SizedBox(
                  width: 15,
                ),
                MyText(
                  room.title,
                  color: whiteColor,
                ),
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
            ),
          );
        }
    );
  }
}