
import '../../../../core/errors/exceptions.dart';
import '../../domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatGroupId,
    required super.senderId,
    required super.content,
    required super.emoji,
    required super.createdAt,
    required super.isRead,
    required super.isSentByUser,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final createdAtString = json['createdAt'] as String?;
    if (createdAtString == null) {
      throw ServerException('createdAt is missing or null');
    }
    return MessageModel(
      id: json['id'] as String,
      chatGroupId: json['chatGroupId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(createdAtString),
      isRead: json['isRead'] as bool,
      isSentByUser: json['isSentByUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatGroupId': chatGroupId,
      'senderId': senderId,
      'content': content,
      'emoji': emoji,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'isSentByUser': isSentByUser,
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      chatGroupId: chatGroupId,
      senderId: senderId,
      content: content,
      emoji: emoji,
      createdAt: createdAt,
      isRead: isRead,
      isSentByUser: isSentByUser,
    );
  }
}