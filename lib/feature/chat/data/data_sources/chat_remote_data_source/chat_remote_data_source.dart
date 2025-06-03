import '../../models/chat_model.dart';
import '../../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getAllChats();
  Future<List<MessageModel>> getChat(String chatGroupId);
}