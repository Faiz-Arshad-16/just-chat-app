import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatGroupId;
  final String senderId;
  final String content;
  final String emoji;
  final DateTime createdAt;
  final bool isRead;
  final bool isSentByUser;

  const MessageEntity({
    required this.id,
    required this.chatGroupId,
    required this.senderId,
    required this.content,
    required this.emoji,
    required this.createdAt,
    required this.isRead,
    required this.isSentByUser,
  });

  @override
  List<Object> get props => [
    id,
    chatGroupId,
    senderId,
    content,
    emoji,
    createdAt,
    isRead,
    isSentByUser,
  ];
}