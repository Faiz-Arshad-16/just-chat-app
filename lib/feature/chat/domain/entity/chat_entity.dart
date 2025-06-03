import 'package:equatable/equatable.dart';
import 'last_message_entity.dart';

class ChatEntity extends Equatable {
  final String chatGroupId;
  final String partnerName;
  final String? partnerProfilePic;
  final LastMessageEntity? lastMessage;
  final int unreadCount;

  const ChatEntity({
    required this.chatGroupId,
    required this.partnerName,
    this.partnerProfilePic,
    this.lastMessage,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
    chatGroupId,
    partnerName,
    partnerProfilePic,
    lastMessage,
    unreadCount,
  ];
}