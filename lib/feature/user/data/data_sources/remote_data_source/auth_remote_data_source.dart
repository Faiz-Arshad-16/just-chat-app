import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<UserModel> fetchProfile();
  Future<void> signOut();
  Future<void> checkAuthStatus();
  String? get authToken;
  Future<UserModel> updateUserProfile(String? name, String? image);
}