import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../user/utils/exceptions/auth_exceptions.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_sources/chat_remote_data_source/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatEntity>>> getAllChats() async {
    try {
      final chatModels = await remoteDataSource.getAllChats();
      final chatEntities = chatModels.map((model) => model.toEntity()).toList();
      return Right(chatEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getChat(String chatGroupId) async {
    try {
      final messageModels = await remoteDataSource.getChat(chatGroupId);
      final messageEntities = messageModels.map((model) => model.toEntity()).toList();
      return Right(messageEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}