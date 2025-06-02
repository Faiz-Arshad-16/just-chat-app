
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// This class is used when a UseCase does not require any parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}

// You can define a generic Params class if you want, but often specific
// Params classes for each use case (like SignInParams, SignUpParams) are better.
// class Params extends Equatable {
//   final Map<String, dynamic> data;
//   const Params({required this.data});
//   @override
//   List<Object> get props => [data];
// }