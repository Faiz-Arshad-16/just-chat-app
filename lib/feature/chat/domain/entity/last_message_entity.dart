import 'package:equatable/equatable.dart';

class LastMessageEntity extends Equatable {
  final String id;
  final String content;
  final String emoji;
  final DateTime createdAt;
  final bool isSentByUser;

  const LastMessageEntity({
    required this.id,
    required this.content,
    required this.emoji,
    required this.createdAt,
    required this.isSentByUser,
  });

  @override
  List<Object> get props => [id, content, emoji, createdAt, isSentByUser];
}
