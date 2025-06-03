import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/message_entity.dart';
import '../repository/chat_repository.dart';

class GetChat {
  final ChatRepository repository;

  GetChat(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(String chatGroupId) async {
    return await repository.getChat(chatGroupId);
  }
}