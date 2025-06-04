import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/errors/exceptions.dart';
import '../../../../user/data/data_sources/local_data_source/auth_local_data_source.dart';
import '../../../../user/utils/exceptions/auth_exceptions.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final AuthLocalDataSource authLocalDataSource;

  ChatRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.authLocalDataSource,
  });

  Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ChatModel>> getAllChats() async {
    String? authToken;
    try {
      final user = await authLocalDataSource.getUser();
      authToken = user?.accessToken;
    } on AppException {
      throw AuthException('No user found in cache');
    }

    if (authToken == null) throw AuthException('No token available');

    final response = await client.get(
      Uri.parse('$baseUrl/chats'),
      headers: _getHeaders(token: authToken),
    );
    print('GetAllChats response: ${response.body}'); // Debug log
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] != 'success') {
        throw ServerException(responseBody['message'] ?? 'Failed to fetch chats');
      }
      final chatData = responseBody['data'] as List;
      return chatData.map((json) => ChatModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw AuthException('Invalid or expired token');
    } else {
      throw ServerException('Failed to fetch chats: ${response.statusCode}');
    }
  }

  @override
  Future<List<MessageModel>> getChat(String chatGroupId) async {
    String? authToken;
    try {
      final user = await authLocalDataSource.getUser();
      authToken = user?.accessToken;
    } on AppException {
      throw AuthException('No user found in cache');
    }

    if (authToken == null) throw AuthException('No token available');

    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatGroupId'),
      headers: _getHeaders(token: authToken),
    );
    print('GetChat response: ${response.body}'); // Debug log
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] != 'success') {
        throw ServerException(responseBody['message'] ?? 'Failed to fetch messages');
      }
      final messageData = responseBody['data']['messages'] as List;
      final chatGroupId = responseBody['data']['chatGroupId'] as String;
      return messageData
          .map((json) => MessageModel.fromJson({
        ...json,
        'chatGroupId': chatGroupId,
      }))
          .toList();
    } else if (response.statusCode == 401) {
      throw AuthException('Invalid or expired token');
    } else {
      throw ServerException('Failed to fetch messages: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteChat(String chatGroupId) async {
    String? authToken;
    try {
      final user = await authLocalDataSource.getUser();
      authToken = user.accessToken;
    } on AppException {
      throw AuthException('No user found in cache');
    }

    if (authToken == null) throw AuthException('No token available');

    final response = await client.delete(
      Uri.parse('$baseUrl/chats/$chatGroupId'),
      headers: _getHeaders(token: authToken),
    );
    print('DelChat response: ${response.body}'); // Debug log
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] != 'success') {
        throw ServerException(responseBody['message'] ?? 'Failed to delete chat');
      }
    } else if (response.statusCode == 401) {
      throw AuthException('Invalid or expired token');
    }  else if (response.statusCode == 403) {
      throw AuthException('Forbidden: User is not part of the chat');
    } else {
      throw ServerException('Failed to delete chat: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteMessage(String id) async {
    String? authToken;
    try {
      final user = await authLocalDataSource.getUser();
      authToken = user?.accessToken;
    } on AppException {
      throw AuthException('No user found in cache');
    }

    if (authToken == null) throw AuthException('No token available');

    final response = await client.delete(
      Uri.parse('$baseUrl/chats/messages/$id'),
      headers: _getHeaders(token: authToken),
    );
    print("Delete message Url: $baseUrl/chats/messages/$id");
    print('DelMessage response: ${response.body}');
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] != 'success') {
        throw ServerException(responseBody['message'] ?? 'Failed to delete message');
      }
    } else if (response.statusCode == 401) {
      throw AuthException('Invalid or expired token');
    }  else if (response.statusCode == 403) {
      throw AuthException('Forbidden: User is not part of the chat');
    } else {
      throw ServerException('Failed to delete message: ${response.statusCode}');
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatGroupId) async {
    String? authToken;
    try {
      final user = await authLocalDataSource.getUser();
      authToken = user?.accessToken;
    } on AppException {
      throw AuthException('No user found in cache');
    }

    if (authToken == null) throw AuthException('No token available');
    
    try {
      final response = await client.patch(
        Uri.parse('$baseUrl/chats/markMessagesAsRead').replace(
          queryParameters: {'id': chatGroupId},),
        headers: _getHeaders(token: authToken),
      );
      print('ChatRemoteDataSource: markMessagesAsRead response: ${response.statusCode}, body: ${response.body}');

      if (response.statusCode != 200) {
        throw ServerException('Failed to mark messages as read: ${response.statusCode}');
      }
    } catch (e) {
      print('ChatRemoteDataSource: markMessagesAsRead error: $e');
      throw ServerException(e.toString());
    }
  }
}
