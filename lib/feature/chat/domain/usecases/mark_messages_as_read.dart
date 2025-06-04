import 'package:dartz/dartz.dart';
import 'package:just_chat_app/core/errors/failure.dart';
import 'package:just_chat_app/feature/chat/domain/repository/chat_repository.dart';

class MarkMessagesAsRead {
  final ChatRepository repository;

  MarkMessagesAsRead(this.repository);

  Future<Either<Failure, void>> call(String chatGroupId) async {
    return await repository.markMessagesAsRead(chatGroupId);
  }
}