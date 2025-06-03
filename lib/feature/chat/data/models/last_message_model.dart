
import '../../../../core/errors/exceptions.dart';
import '../../domain/entity/last_message_entity.dart';

class LastMessageModel extends LastMessageEntity {
  const LastMessageModel({
    required super.id,
    required super.content,
    required super.emoji,
    required super.createdAt,
    required super.isSentByUser,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    final createdAtString = json['createdAt'] as String?;
    if (createdAtString == null) {
      throw ServerException('createdAt is missing or null');
    }
    return LastMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(createdAtString),
      isSentByUser: json['isSentByUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'emoji': emoji,
      'createdAt': createdAt.toIso8601String(),
      'isSentByUser': isSentByUser,
    };
  }
}