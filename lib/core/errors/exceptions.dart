
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() {
    return 'AppException: $message';
  }
}

class ServerException extends AppException {
  ServerException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}