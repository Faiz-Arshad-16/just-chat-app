
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred.']);

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error.']);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message = 'No internet connection. Please check your network.']);
}

// Specific authentication failures
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}