
import '../../domain/entity/chat_entity.dart';
import 'last_message_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.chatGroupId,
    required super.partnerName,
    required super.partnerId,
    super.partnerProfilePic,
    LastMessageModel? super.lastMessage,
    required super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final lastMessageJson = json['lastMessage'] as Map<String, dynamic>?;
    return ChatModel(
      chatGroupId: json['chatGroupId'] as String,
      partnerName: json['partnerName'] as String,
      partnerId: json['partnerId'] as String,
      partnerProfilePic: json['partnerProfilePic'] as String?,
      lastMessage:
      lastMessageJson != null ? LastMessageModel.fromJson(lastMessageJson) : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatGroupId': chatGroupId,
      'partnerName': partnerName,
      'partnerId': partnerId,
      'partnerProfilePic': partnerProfilePic,
      'lastMessage': (lastMessage as LastMessageModel?)?.toJson(),
      'unreadCount': unreadCount,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      chatGroupId: chatGroupId,
      partnerName: partnerName,
      partnerId: partnerId,
      partnerProfilePic: partnerProfilePic,
      lastMessage: lastMessage,
      unreadCount: unreadCount,
    );
  }
}