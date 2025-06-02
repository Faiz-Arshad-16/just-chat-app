import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/errors/exceptions.dart';
import '../../../utils/exceptions/auth_exceptions.dart';
import '../../models/user_model.dart';
import '../local_data_source/auth_local_data_source.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource localDataSource;
  final String baseUrl = 'https://just-chat-backend-production.up.railway.app';
  String? _authToken;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.localDataSource,
  });

  @override
  String? get authToken => _authToken;
  void setAuthToken(String token) {
    _authToken = token;
  }
  Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: _getHeaders(),
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        _authToken = responseBody['data']['access_token'] as String;
        final user = await fetchProfile();
        await localDataSource.cacheUser(user, _authToken!);
        return user;
      } else {
        throw ServerException(responseBody['message'] ?? 'Login failed');
      }
    } else if (response.statusCode == 401) {
      throw AuthException.invalidCredentials();
    } else {
      throw ServerException('Failed to sign in: ${response.statusCode}');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _getHeaders(),
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        _authToken = responseBody['data']['access_token'] as String;
        await localDataSource.clearUserCache();
        final user = await fetchProfile();
        await localDataSource.cacheUser(user, _authToken!);
        return user;
      } else {
        throw ServerException(responseBody['message'] ?? 'Signup failed');
      }
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw ServerException(responseBody['message'] ?? 'Invalid signup data');
    } else if (response.statusCode == 409) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw ServerException(responseBody['message'] ?? 'Email already exists');
    } else if (response.statusCode == 401) {
      throw AuthException.invalidCredentials();
    } else {
      throw ServerException('Failed to signup: ${response.statusCode}');
    }
  }

  @override
  Future<UserModel> fetchProfile() async {
    if (_authToken == null) {
      throw AuthException.noToken();
    }
    final response = await client.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _getHeaders(token: _authToken),
    );
    print('Profile response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        // Fetch ID from local cache
        String? id;
        try {
          final localUser = await localDataSource.getUser();
          id = localUser.id;
        } catch (e) {
          id = null; // Fallback if local data is unavailable
        }
        return UserModel.fromProfileJson(responseBody, accessToken: _authToken, id: id);
      } else {
        throw ServerException(responseBody['message'] ?? 'Failed to fetch profile');
      }
    } else if (response.statusCode == 401) {
      throw AuthException.unauthenticated();
    } else {
      throw ServerException('Failed to fetch profile: ${response.statusCode}');
    }
  }

  @override
  Future<void> signOut() async {
    if (_authToken == null) {
      throw AuthException.noToken();
    }
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/signout'),
        headers: _getHeaders(token: _authToken),
      );
      if (response.statusCode == 201) {
        _authToken = null;
        await localDataSource.clearUserCache();
      } else {
        throw AppException('Failed to logout on server: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> checkAuthStatus() async {
    final savedToken = await localDataSource.getToken();
    if (savedToken != null) {
      _authToken = savedToken;
      try {
        await fetchProfile();
      } catch (e) {
        _authToken = null;
        await localDataSource.clearUserCache();
        rethrow;
      }
    } else {
      throw AuthException.noToken();
    }
  }

  @override
  Future<UserModel> updateUserProfile(String? name, String? image) async {
    if (_authToken == null) throw AuthException.noToken();

    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (image != null) body['image'] = image;

    try {
      final response = await client.patch(
        Uri.parse('$baseUrl/user/update'),
        body: json.encode(body),
        headers: _getHeaders(token: _authToken),
      );

      print('Update response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          // Fetch ID from local cache
          String? id;
          try {
            final localUser = await localDataSource.getUser();
            id = localUser.id;
          } catch (e) {
            id = null; // Fallback if local data is unavailable
          }
          final user = UserModel.fromProfileJson(
            responseBody,
            accessToken: _authToken,
            id: id,
          );
          await localDataSource.cacheUser(user, _authToken!);
          return user;
        } else {
          throw ServerException(responseBody['message'] ?? 'Failed to update profile');
        }
      } else {
        throw ServerException('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user profile: $e'); // Debug log
      rethrow;
    }
  }

}
