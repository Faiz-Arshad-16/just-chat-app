
import '../../../../core/errors/exceptions.dart';

class AuthException extends AppException {
  AuthException(super.message);

  factory AuthException.invalidCredentials() => AuthException('Invalid email or password.');
  factory AuthException.emailAlreadyInUse() => AuthException('The email address is already in use by another account.');
  factory AuthException.noToken() => AuthException('Authentication token not found or invalid.');
  factory AuthException.unauthenticated() => AuthException('You are not authenticated. Please log in again.');

}