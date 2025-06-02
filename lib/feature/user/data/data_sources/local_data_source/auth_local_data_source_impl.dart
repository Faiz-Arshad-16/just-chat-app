import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_USER = 'CACHED_USER';
  static const String CACHED_TOKEN = 'CACHED_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user, String token) async {
    await Future.wait([
      sharedPreferences.setString(
        CACHED_USER,
        json.encode(user.toJson()),
      ),
      sharedPreferences.setString(CACHED_TOKEN, token),
    ]);
  }


  @override
  Future<UserModel> getUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException('No user found in cache');
    }
  }

  @override
  Future<String?> getToken() async {
    final token = sharedPreferences.getString(CACHED_TOKEN);
    return token;
  }

  @override
  Future<void> clearUserCache() async {
    await Future.wait([
      sharedPreferences.remove(CACHED_USER),
      sharedPreferences.remove(CACHED_TOKEN),
    ]);
  }
}
