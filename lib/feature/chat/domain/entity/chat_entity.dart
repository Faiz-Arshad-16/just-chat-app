import 'package:equatable/equatable.dart';
import 'last_message_entity.dart';

class ChatEntity extends Equatable {
  final String chatGroupId;
  final String partnerName;
  final String partnerId;
  final String? partnerProfilePic;
  final LastMessageEntity? lastMessage;
  final int unreadCount;

  const ChatEntity({
    required this.chatGroupId,
    required this.partnerName,
    required this.partnerId,
    this.partnerProfilePic,
    this.lastMessage,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
    chatGroupId,
    partnerName,
    partnerId,
    partnerProfilePic,
    lastMessage,
    unreadCount,
  ];
}