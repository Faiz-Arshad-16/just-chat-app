import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);

  Future<Either<Failure, UserEntity>> signUp(String name, String email, String password);

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity>> getUserProfile();

  Future<Either<Failure, UserEntity>> updateUserProfile(String? name, String? image,);

}