
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entity/user_entity.dart';
import '../../repository/auth_repository.dart';

class GetUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}