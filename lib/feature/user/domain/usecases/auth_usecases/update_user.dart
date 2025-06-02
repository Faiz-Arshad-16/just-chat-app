import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repository/auth_repository.dart';
import '../../entity/user_entity.dart';

class UpdateUser implements UseCase<UserEntity, UpdateUserParams> {
  final AuthRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await repository.updateUserProfile(params.name, params.image);
  }
}

class UpdateUserParams extends Equatable {
  final String? name;
  final String? image;

  const UpdateUserParams({this.name, this.image});

  @override
  List<Object?> get props => [name, image];
}