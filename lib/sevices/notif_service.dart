import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:isyarat_kita/component/color.dart';
import 'package:isyarat_kita/sevices/chat_socket.dart';
import 'package:isyarat_kita/sevices/user_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotifService {
  static final NotifService _instance = NotifService._internal();
  factory NotifService() => _instance;

  late final IO.Socket _socket;

  NotifService._internal() {
    _socket = ChatSocket().socket;
    _initializeSocket();
  }

  static Future<void> initialize() async {
    try {
      await AwesomeNotifications().initialize(
        null, //Icon Apk
        [
          NotificationChannel(
            channelKey: 'community_channel',
            channelName: 'Isyarat Kita Notification',
            channelDescription: 'Notification For Isyarat Kita',
            ledColor: secondaryColor,
            defaultColor: primaryColor,
            importance: NotificationImportance.Max,
            playSound: true,
            enableLights: true,
            enableVibration: true,
          ),
        ],
      );

      await AwesomeNotifications().requestPermissionToSendNotifications();
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  void _initializeSocket() {
    _socket.connect();

    _socket.onConnect((_) {
      print("Socket connected: ${_socket.id}");
      _listenToSocketNotifications();
    });

    _socket.onDisconnect((_) {
      print("Socket disconnected");
    });

    _socket.onConnectError((data) {
      print("Socket connect error: $data");
    });
  }

  Future<void> _listenToSocketNotifications() async {
    try {
      final currentUser = await UserService().getCurrentUserLocal();
      final currentUserId = currentUser.userId;

      if (currentUserId.isEmpty) return;
      final notif = _socket.on("newMessage", (data) async {
        if (data['senderId'] != currentUserId) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              channelKey: 'community_channel',
              title: data['title'],
              body: data['content'],
              notificationLayout: NotificationLayout.Default,
              payload: {
                'roomId': data['roomId'],
                'senderId': data['senderId'],
              },
            ),
          );
        }
      });

      print('Notif: $notif');
    } catch (e) {
      print("Error listening to notifications: $e");
    }
  }

  // static Future<void> showNotification({
  //   required List<String> receiverIds,
  //   required String title,
  //   required String message,
  //   required String roomId,
  //   required String currentUserId
  // }) async {
  //   try {
  //
  //     final filteredReceivers = receiverIds.where((id) => id != currentUserId).toList();
  //     if (filteredReceivers.isNotEmpty) {
  //       await _firestore.collection('chat_notifications').add({
  //         'title': title,
  //         'body': message,
  //         'senderId': currentUserId,
  //         'receiverId': filteredReceivers,
  //         'roomId': roomId,
  //         'timestamp': FieldValue.serverTimestamp(),
  //         'isRead': false,
  //       });
  //     }
  //   } catch (e) {
  //     print("Error in showNotification: $e");
  //   }
  // }

  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
