import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user, String token);
  Future<UserModel> getUser();
  Future<String?> getToken();
  Future<void> clearUserCache();
}