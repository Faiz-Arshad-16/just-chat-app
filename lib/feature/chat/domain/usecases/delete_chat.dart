import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/chat_repository.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<Either<Failure, void>> call(String chatGroupId) async {
    return await repository.deleteChat(chatGroupId);
  }
}