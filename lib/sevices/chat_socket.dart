import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
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

    socket.connect();
    print('isConnected?: ${socket.connected}');
  }
}