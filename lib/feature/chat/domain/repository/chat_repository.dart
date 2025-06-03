import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/chat_entity.dart';
import '../entity/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getAllChats();
  Future<Either<Failure, List<MessageEntity>>> getChat(String chatGroupId);
}