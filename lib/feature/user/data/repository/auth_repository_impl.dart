import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../utils/exceptions/auth_exceptions.dart';
import '../data_sources/local_data_source/auth_local_data_source.dart';
import '../data_sources/remote_data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.signIn(email, password);
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred during sign in.'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(String name, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.signUp(email, password, name);
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('An unexpected error occurred during sign up.'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during sign out.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return Left(AuthFailure('No authentication token found'));
      }

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.checkAuthStatus();
          final remoteUser = await remoteDataSource.fetchProfile();
          return Right(remoteUser);
        } on ServerException catch (e) {
          return Left(ServerFailure(e.message));
        } on AuthException catch (e) {
          await localDataSource.clearUserCache();
          return Left(AuthFailure(e.message));
        } catch (e) {
          return Left(ServerFailure('An unexpected error occurred during remote profile fetch.'));
        }
      } else {
        try {
          final localUser = await localDataSource.getUser();
          return Right(localUser);
        } on CacheException {
          return Left(NoInternetFailure());
        }
      }
    } on CacheException {
      return Left(CacheFailure('No cached user data available'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred while getting user profile.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(String? name, String? image) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateUserProfile(name, image);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

}
