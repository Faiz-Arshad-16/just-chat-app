import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/chat_repository.dart';

class DeleteMessage {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteMessage(id);
  }
}