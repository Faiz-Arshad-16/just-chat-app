// import 'package:just_chat_app/feature/chat/data/data_sources/chat_socket_service/chat_socket_service.dart';
// import 'package:just_chat_app/feature/user/data/data_sources/local_data_source/auth_local_data_source.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class ChatSocketServiceImpl implements ChatSocketService {
//   final AuthLocalDataSource authLocalDataSource;
//   late IO.Socket socket;
//
//   ChatSocketServiceImpl(this.authLocalDataSource);
//
//   @override
//   Future<void> connect() async {
//     final token = await authLocalDataSource.getToken();
//
//     if (token == null || token.isEmpty) {
//       print('❌ Token is null or empty. Cannot connect to socket.');
//       return;
//     }
//
//     print('🔌 Connecting with token from local storage: $token');
//
//      socket = IO.io(
//       'https://just-chat-backend-production.up.railway.app/chat',
//       IO.OptionBuilder()
//           .setTransports(['websocket']) // required for Flutter apps
//           .enableAutoConnect()
//           .setExtraHeaders({'token': token}) // if needed
//           .build(),
//     );
//
//     // Event: connected
//     socket.onConnect((_) {
//       print('✅ Socket connected');
//     });
//
//     // Event: connection error
//     socket.onConnectError((data) {
//       print('❌ Socket connection error: $data');
//     });
//
//     // Event: general error
//     socket.onError((data) {
//       print('❌ General socket error: $data');
//     });
//
//     // Event: disconnected
//     socket.onDisconnect((_) {
//       print('⚠️ Socket disconnected');
//     });
//
//     socket.connect();
//   }
//
//
//   @override
//   void disconnect() {
//     socket.disconnect();
//     socket.clearListeners();
//     print("🔌 Socket disconnected manually");
//   }
//
//   @override
//   Map<String, dynamic> onChatUpdated() {
//     socket.on('chatUpdated', (data) {
//       if (data is Map<String, dynamic>) {
//         print('ChatSocketService: Received chatUpdated: $data');
//
//       } else {
//         print('ChatSocketService: Invalid chatUpdated data: $data');
//
//       }
//       return data;
//     });
//     return {};
//   }
//
//   @override
//   void sendMessage(Map<String, dynamic> messageContent) {
//     socket.emit('sendMessage', messageContent);
//   }
// }

import 'dart:convert';
import 'package:just_chat_app/feature/chat/data/data_sources/chat_socket_service/chat_socket_service.dart';
import 'package:just_chat_app/feature/user/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketServiceImpl implements ChatSocketService {
  IO.Socket? _socket;
  final AuthLocalDataSource authLocalDataSource;

  ChatSocketServiceImpl(this.authLocalDataSource);

  @override
  Future<void> connect() async {
    final token = await authLocalDataSource.getToken();

    if (token == null || token.isEmpty) {
      print('❌ Token is null or empty. Cannot connect to socket.');
      return;
    }

    print('🔌 Connecting with token: $token');

    try {
      _socket = IO.io(
        'wss://just-chat-backend-production.up.railway.app/chat',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders({'token': token})
            .build(),
      );

      _socket!.onConnect((_) {
        print('✅ Socket connected');
      });

      _socket!.onConnectError((data) {
        print('❌ Socket connection error: $data');
        _socket = null;
      });

      _socket!.onError((data) {
        print('❌ General socket error: $data');
      });

      _socket!.onDisconnect((_) {
        print('⚠️ Socket disconnected');
        _socket = null;
      });

      _socket!.connect();
    } catch (e) {
      print('❌ Error initializing socket: $e');
      _socket = null;
    }
  }

  @override
  void disconnect() {
    print('🔌 Disconnecting socket');
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket = null;
      print('✅ Socket disconnected manually');
    } else {
      print('ℹ️ Socket already disconnected or not initialized');
    }
  }

  @override
  void onChatUpdated(void Function(Map<String, dynamic> data) callback) {
    print('🔧 Setting up chatUpdated listener');
    if (_socket == null) {
      print('❌ Cannot set up chatUpdated listener: Socket not connected');
      return;
    }
    try {
      _socket!.on('chatUpdated', (data) {
        if (data is Map<String, dynamic>) {
          print('📬 ChatSocketService: Received chatUpdated: $data');
          callback(data);
        } else {
          print('❌ ChatSocketService: Invalid chatUpdated data: $data');
        }
      });
    } catch (e) {
      print('❌ Error setting up chatUpdated listener: $e');
    }
  }

  @override
  void onMessage(void Function(Map<String, dynamic> data) callback) {
    print('🔧 Setting up message listener');
    if (_socket == null) {
      print('❌ Cannot set up message listener: Socket not connected');
      return;
    }
    try {
      _socket!.on('message', (data) {
        if (data is Map<String, dynamic>) {
          print('📬 ChatSocketService: Received message: $data');
          callback(data);
        } else {
          print('❌ ChatSocketService: Invalid message data: $data');
        }
      });
    } catch (e) {
      print('❌ Error setting up message listener: $e');
    }
  }

  @override
  void sendMessage(Map<String, dynamic> messageContent) {
    print('📤 ChatSocketService: Sending message: $messageContent');
    if (_socket == null) {
      print('❌ Cannot send message: Socket not connected');
      return;
    }
    try {
      _socket!.emit('sendMessage', messageContent);
      print('✅ ChatSocketService: Message sent');
    } catch (e) {
      print('❌ ChatSocketService: Error sending message: $e');
    }
  }
}