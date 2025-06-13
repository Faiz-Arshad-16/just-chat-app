abstract class ChatSocketService {
  Future<void> connect();
  void disconnect();
  void sendMessage(Map<String, dynamic> messageContent);
  // void chatUpdated(Function(dynamic data) callback);
  void onChatUpdated(void Function(Map<String, dynamic> data) callback);
  void onMessage(void Function(Map<String, dynamic> data) callback);
}