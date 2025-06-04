import '../../models/chat_model.dart';
import '../../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getAllChats();
  Future<List<MessageModel>> getChat(String chatGroupId);
  Future<void> deleteChat(String chatGroupId);
  Future<void> deleteMessage(String id);
  Future<void> markMessagesAsRead(String chatGroupId);
}