import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket {
  late final IO.Socket socket;

  ChatSocket() {
    final String? api = dotenv.env['MOBILE_API'];
    if (api == null) {
      throw Exception('MOBILE_API not found in environment variables');
    }
    socket = IO.io(
      api,
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
    );
    socket.onConnect((_) {
      socket.onConnect((_) {
        print('Socket connected!s');
      });
    });

    socket.onConnectError((error) {
      print('Connection Error: $error');
    });

    socket.onError((error) {
      print('Error: $error');
    });

    socket.connect();
    print('isConnected?: ${socket.connected}');
  }
}