// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:just_chat_app/feature/chat/domain/usecases/delete_chat.dart';
// import 'package:just_chat_app/feature/chat/domain/usecases/delete_message.dart';
// import 'package:just_chat_app/feature/chat/domain/usecases/mark_messages_as_read.dart';
// import '../../../../core/errors/failure.dart';
// import '../../data/data_sources/chat_socket_service/chat_socket_service.dart';
// import '../../domain/entity/chat_entity.dart';
// import '../../domain/entity/last_message_entity.dart';
// import '../../domain/entity/message_entity.dart';
// import '../../domain/usecases/get_all_chats.dart';
// import '../../domain/usecases/get_chat.dart';
//
// part 'chat_state.dart';
//
// class ChatCubit extends Cubit<ChatState> {
//   final GetAllChats getAllChatsUseCase;
//   final GetChat getChatUseCase;
//   final DeleteChat deleteChatUseCase;
//   final DeleteMessage deleteMessageUseCase;
//   final MarkMessagesAsRead markMessagesAsReadUseCase;
//   final ChatSocketService chatSocketService;
//
//   ChatCubit({
//     required this.getAllChatsUseCase,
//     required this.getChatUseCase,
//     required this.deleteChatUseCase,
//     required this.deleteMessageUseCase,
//     required this.markMessagesAsReadUseCase,
//     required this.chatSocketService,
//   }) : super(ChatInitial());
//
//   void fetchAllChats() async {
//     print('ChatCubit: Fetching all chats');
//     emit(ChatLoading(chats: state.chats, messages: state.messages));
//     try {
//       final result = await getAllChatsUseCase();
//       result.fold(
//             (failure) {
//           print('ChatCubit: Error fetching chats: ${failure.message}');
//           emit(ChatError(
//             message: _mapFailureToMessage(failure),
//             chats: state.chats,
//             messages: state.messages,
//           ));
//         },
//             (chats) {
//           print('ChatCubit: Chats loaded: ${chats.length}, type: ${chats.runtimeType}');
//           emit(ChatLoaded(chats: chats, messages: state.messages));
//         },
//       );
//     } catch (e) {
//       print('ChatCubit: Unexpected error: $e');
//       emit(ChatError(
//         message: 'Unexpected error: $e',
//         chats: state.chats,
//         messages: state.messages,
//       ));
//     }
//   }
//
//   void fetchChat(String chatGroupId) async {
//     print('ChatCubit: Fetching chat $chatGroupId');
//     emit(ChatLoading(chats: state.chats, messages: state.messages));
//     try {
//       final result = await getChatUseCase(chatGroupId);
//       result.fold(
//             (failure) {
//           print('ChatCubit: Error fetching messages: ${failure.message}');
//           emit(ChatError(
//             message: _mapFailureToMessage(failure),
//             chats: state.chats,
//             messages: state.messages,
//           ));
//         },
//             (messages) {
//           print('ChatCubit: Messages loaded: ${messages.length}');
//           emit(ChatLoaded(chats: state.chats, messages: messages));
//         },
//       );
//     } catch (e) {
//       print('ChatCubit: Unexpected error: $e');
//       emit(ChatError(
//         message: 'Unexpected error: $e',
//         chats: state.chats,
//         messages: state.messages,
//       ));
//     }
//   }
//
//   void deleteChat(String chatGroupId) async {
//     print('ChatCubit: Deleting chat $chatGroupId');
//     emit(ChatLoading(chats: state.chats, messages: state.messages));
//     try {
//       final result = await deleteChatUseCase(chatGroupId);
//       result.fold(
//             (failure) {
//           print('ChatCubit: Error Deleting chat: ${failure.message}');
//           emit(ChatError(
//             message: _mapFailureToMessage(failure),
//             chats: state.chats,
//             messages: state.messages,
//           ));
//         },
//             (_) {
//           emit(const ChatLoaded());
//         },
//       );
//     } catch (e) {
//       print('ChatCubit: Unexpected error: $e');
//       emit(ChatError(
//         message: 'Unexpected error: $e',
//         chats: state.chats,
//         messages: state.messages,
//       ));
//     }
//   }
//
//   void deleteMessage(String id) async {
//     print('ChatCubit: Deleting message $id');
//     print('ChatCubit: Current messages: ${state.messages.map((m) => m.id).toList()}');
//     emit(ChatLoading(chats: state.chats, messages: state.messages));
//     try {
//       final deleteResult = await deleteMessageUseCase(id);
//       deleteResult.fold(
//             (failure) {
//           print('ChatCubit: Error deleting message: ${failure.message}');
//           emit(ChatError(
//             message: _mapFailureToMessage(failure),
//             chats: state.chats,
//             messages: state.messages,
//           ));
//         },
//             (_) async {
//           print('ChatCubit: Message deleted: $id');
//           // Remove the deleted message locally
//           final updatedMessages = state.messages.where((m) => m.id != id).toList();
//
//           // Find the chatGroupId of the deleted message
//           final deletedMessage = state.messages.firstWhere(
//                 (m) => m.id == id,
//             orElse: () => state.messages.isNotEmpty
//                 ? state.messages.first
//                 : MessageEntity(
//               id: '',
//               chatGroupId: '',
//               senderId: '',
//               content: '',
//               createdAt: DateTime.now(),
//               isSentByUser: false, emoji: '', isRead: false,
//             ),
//           );
//           final chatGroupId = deletedMessage.chatGroupId;
//
//           // Fetch the updated chat to get the new lastMessage
//           final chatResult = await getChatUseCase(chatGroupId);
//           chatResult.fold(
//                 (failure) {
//               print('ChatCubit: Error fetching updated chat: ${failure.message}');
//               // Fallback to local update with no lastMessage
//               final updatedChats = state.chats.map((chat) {
//                 if (chat.chatGroupId == chatGroupId) {
//                   return ChatEntity(
//                     chatGroupId: chat.chatGroupId,
//                     partnerName: chat.partnerName,
//                     partnerId: chat.partnerId,
//                     partnerProfilePic: chat.partnerProfilePic,
//                     lastMessage: null, unreadCount: chat.unreadCount,
//                   );
//                 }
//                 return chat;
//               }).toList();
//               emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
//             },
//                 (fetchedMessages) {
//               // Update the chats list with the fetched chat's lastMessage
//               final updatedChats = state.chats.map((chat) {
//                 if (chat.chatGroupId == chatGroupId) {
//                   final newLastMessage = fetchedMessages.isNotEmpty
//                       ? fetchedMessages.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b)
//                       : null;
//                   return ChatEntity(
//                     chatGroupId: chat.chatGroupId,
//                     partnerName: chat.partnerName,
//                     partnerId: chat.partnerId,
//                     partnerProfilePic: chat.partnerProfilePic,
//                     unreadCount: chat.unreadCount,
//                     lastMessage: newLastMessage != null
//                         ? LastMessageEntity(
//                       content: newLastMessage.content,
//                       createdAt: newLastMessage.createdAt,
//                       id: newLastMessage.id,
//                       emoji: newLastMessage.emoji,
//                       isSentByUser: newLastMessage.isSentByUser,
//                     )
//                         : null,
//                   );
//                 }
//                 return chat;
//               }).toList();
//
//               print('ChatCubit: Updated messages: ${updatedMessages.map((m) => m.id).toList()}');
//               print('ChatCubit: Updated last message for chat $chatGroupId: ${fetchedMessages.isNotEmpty ? fetchedMessages.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b).content : "No messages"}');
//               emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
//             },
//           );
//         },
//       );
//     } catch (e) {
//       print('ChatCubit: Unexpected error: $e');
//       emit(ChatError(
//         message: 'Unexpected error: $e',
//         chats: state.chats,
//         messages: state.messages,
//       ));
//     }
//   }
//
//   void markMessagesAsRead(String chatId) async {
//     print('ChatCubit: Marking messages as read for chat $chatId');
//     emit(ChatLoading(chats: state.chats, messages: state.messages));
//     try {
//       final result = await markMessagesAsReadUseCase(chatId);
//       result.fold(
//             (failure) {
//           print('ChatCubit: Error marking messages as read: ${failure.message}');
//           emit(ChatError(
//             message: _mapFailureToMessage(failure),
//             chats: state.chats,
//             messages: state.messages,
//           ));
//         },
//             (_) {
//           print('ChatCubit: Messages marked as read for chat $chatId');
//           // Update messages to set isRead: true for non-user messages
//           final updatedMessages = state.messages.map((message) {
//             if (message.chatGroupId == chatId && !message.isRead && !message.isSentByUser) {
//               return MessageEntity(
//                 id: message.id,
//                 chatGroupId: message.chatGroupId,
//                 senderId: message.senderId,
//                 content: message.content,
//                 emoji: message.emoji,
//                 createdAt: message.createdAt,
//                 isRead: true,
//                 isSentByUser: message.isSentByUser,
//               );
//             }
//             return message;
//           }).toList();
//
//           // Update chats to set unreadCount: 0
//           final updatedChats = state.chats.map((chat) {
//             if (chat.chatGroupId == chatId) {
//               return ChatEntity(
//                 chatGroupId: chat.chatGroupId,
//                 partnerName: chat.partnerName,
//                 partnerId: chat.partnerId,
//                 partnerProfilePic: chat.partnerProfilePic,
//                 lastMessage: chat.lastMessage,
//                 unreadCount: 0,
//               );
//             }
//             return chat;
//           }).toList();
//
//           print('ChatCubit: Updated messages isRead: ${updatedMessages.where((m) => m.chatGroupId == chatId).map((m) => m.isRead).toList()}');
//           print('ChatCubit: Updated chats unreadCount: ${updatedChats.where((c) => c.chatGroupId == chatId).map((c) => c.unreadCount).toList()}');
//           emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
//         },
//       );
//     } catch (e) {
//       print('ChatCubit: Unexpected error: $e');
//       emit(ChatError(
//         message: 'Unexpected error: $e',
//         chats: state.chats,
//         messages: state.messages,
//       ));
//     }
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'Server Error: ${failure.message}';
//       case AuthFailure:
//         return 'Authentication Error: ${failure.message}';
//       default:
//         return 'Unexpected Error: ${failure.message}';
//     }
//   }
//
//   Future<void> sendMessage(Map<String, dynamic> messageContent) async {
//     print('ChatCubit: Sending message: $messageContent');
//     emit(ChatLoading(chats: state.chats, messages: state.messages));
//     try {
//       chatSocketService.sendMessage(messageContent);
//       print('ChatCubit: Message sent successfully');
//       chatSocketService.onChatUpdated();
//       print("Chats  $state.chats");
//       // map the state.chats and find if the chatGroupId exists by using chatgroup id to find it if
//       // it exists then update the last message else push new message into the state.chats array
//       emit(ChatLoaded(chats: state.chats, messages: state.messages));
//     } catch (e) {
//       print('ChatCubit: Error sending message: $e');
//       emit(ChatError(
//         message: 'Error sending message: $e',
//         chats: state.chats,
//         messages: state.messages,
//       ));
//     }
//   }
//
//
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_chat_app/core/errors/failure.dart';
import 'package:just_chat_app/feature/chat/data/data_sources/chat_socket_service/chat_socket_service.dart';
import 'package:just_chat_app/feature/chat/domain/entity/chat_entity.dart';
import 'package:just_chat_app/feature/chat/domain/entity/last_message_entity.dart';
import 'package:just_chat_app/feature/chat/domain/entity/message_entity.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/delete_chat.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/delete_message.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/get_all_chats.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/get_chat.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/mark_messages_as_read.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetAllChats getAllChatsUseCase;
  final GetChat getChatUseCase;
  final DeleteChat deleteChatUseCase;
  final DeleteMessage deleteMessageUseCase;
  final MarkMessagesAsRead markMessagesAsReadUseCase;
  final ChatSocketService chatSocketService;
  bool _isListenerInitialized = false;
  String? _currentChatGroupId;
  String? _currentUserId = 'cmb7xibxl0000pn0ri108j82f'; // Hardcoded for now
  String? _optimisticMessageId;

  ChatCubit({
    required this.getAllChatsUseCase,
    required this.getChatUseCase,
    required this.deleteChatUseCase,
    required this.deleteMessageUseCase,
    required this.markMessagesAsReadUseCase,
    required this.chatSocketService,
  }) : super(ChatInitial());

  void fetchAllChats() async {
    print('ChatCubit: Fetching all chats');
    initChatUpdates();
    emit(ChatLoading(chats: state.chats, messages: state.messages));
    try {
      final result = await getAllChatsUseCase();
      result.fold(
            (failure) {
          print('ChatCubit: Error fetching chats: ${failure.message}');
          emit(ChatError(
            message: _mapFailureToMessage(failure),
            chats: state.chats,
            messages: state.messages,
          ));
        },
            (chats) {
          print('ChatCubit: Chats loaded: ${chats.length}, type: ${chats.runtimeType}');
          emit(ChatLoaded(chats: chats, messages: state.messages));
        },
      );
    } catch (e) {
      print('ChatCubit: Unexpected error: $e');
      emit(ChatError(
        message: 'Unexpected error: $e',
        chats: state.chats,
        messages: state.messages,
      ));
    }
  }

  void fetchChat(String chatGroupId) async {
    print('ChatCubit: Fetching chat $chatGroupId');
    _currentChatGroupId = chatGroupId;
    emit(ChatLoading(chats: state.chats, messages: state.messages));
    try {
      final result = await getChatUseCase(chatGroupId);
      result.fold(
            (failure) {
          print('ChatCubit: Error fetching messages: ${failure.message}');
          emit(ChatError(
            message: _mapFailureToMessage(failure),
            chats: state.chats,
            messages: state.messages,
          ));
        },
            (messages) {
          print('ChatCubit: Messages loaded: ${messages.length}');
          emit(ChatLoaded(chats: state.chats, messages: messages));
        },
      );
    } catch (e) {
      print('ChatCubit: Unexpected error: $e');
      emit(ChatError(
        message: 'Unexpected error: $e',
        chats: state.chats,
        messages: state.messages,
      ));
    }
  }

  void deleteChat(String chatGroupId) async {
    print('ChatCubit: Deleting chat $chatGroupId');
    emit(ChatLoading(chats: state.chats, messages: state.messages));
    try {
      final result = await deleteChatUseCase(chatGroupId);
      result.fold(
            (failure) {
          print('ChatCubit: Error Deleting chat: ${failure.message}');
          emit(ChatError(
            message: _mapFailureToMessage(failure),
            chats: state.chats,
            messages: state.messages,
          ));
        },
            (_) {
          emit(const ChatLoaded());
        },
      );
    } catch (e) {
      print('ChatCubit: Unexpected error: $e');
      emit(ChatError(
        message: 'Unexpected error: $e',
        chats: state.chats,
        messages: state.messages,
      ));
    }
  }

  void deleteMessage(String id) async {
    print('ChatCubit: Deleting message $id');
    print('ChatCubit: Current messages: ${state.messages.map((m) => m.id).toList()}');
    emit(ChatLoading(chats: state.chats, messages: state.messages));
    try {
      final deleteResult = await deleteMessageUseCase(id);
      deleteResult.fold(
            (failure) {
          print('ChatCubit: Error deleting message: ${failure.message}');
          emit(ChatError(
            message: _mapFailureToMessage(failure),
            chats: state.chats,
            messages: state.messages,
          ));
        },
            (_) async {
          print('ChatCubit: Message deleted: $id');
          final updatedMessages = state.messages.where((m) => m.id != id).toList();
          final deletedMessage = state.messages.firstWhere(
                (m) => m.id == id,
            orElse: () => state.messages.isNotEmpty
                ? state.messages.first
                : MessageEntity(
              id: '',
              chatGroupId: '',
              senderId: '',
              content: '',
              createdAt: DateTime.now(),
              isSentByUser: false,
              emoji: '',
              isRead: false,
            ),
          );
          final chatGroupId = deletedMessage.chatGroupId;
          final chatResult = await getChatUseCase(chatGroupId);
          chatResult.fold(
                (failure) {
              print('ChatCubit: Error fetching updated chat: ${failure.message}');
              final updatedChats = state.chats.map((chat) {
                if (chat.chatGroupId == chatGroupId) {
                  return ChatEntity(
                    chatGroupId: chat.chatGroupId,
                    partnerName: chat.partnerName,
                    partnerId: chat.partnerId,
                    partnerProfilePic: chat.partnerProfilePic,
                    lastMessage: null,
                    unreadCount: chat.unreadCount,
                  );
                }
                return chat;
              }).toList();
              emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
            },
                (fetchedMessages) {
              final updatedChats = state.chats.map((chat) {
                if (chat.chatGroupId == chatGroupId) {
                  final newLastMessage = fetchedMessages.isNotEmpty
                      ? fetchedMessages.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b)
                      : null;
                  return ChatEntity(
                    chatGroupId: chat.chatGroupId,
                    partnerName: chat.partnerName,
                    partnerId: chat.partnerId,
                    partnerProfilePic: chat.partnerProfilePic,
                    unreadCount: chat.unreadCount,
                    lastMessage: newLastMessage != null
                        ? LastMessageEntity(
                      content: newLastMessage.content,
                      createdAt: newLastMessage.createdAt,
                      id: newLastMessage.id,
                      emoji: newLastMessage.emoji,
                      isSentByUser: newLastMessage.isSentByUser,
                    )
                        : null,
                  );
                }
                return chat;
              }).toList();
              print('ChatCubit: Updated messages: ${updatedMessages.map((m) => m.id).toList()}');
              print('ChatCubit: Updated last message for chat $chatGroupId: ${fetchedMessages.isNotEmpty ? fetchedMessages.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b).content : "No messages"}');
              emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
            },
          );
        },
      );
    } catch (e) {
      print('ChatCubit: Unexpected error: $e');
      emit(ChatError(
        message: 'Unexpected error: $e',
        chats: state.chats,
        messages: state.messages,
      ));
    }
  }

  void markMessagesAsRead(String chatId) async {
    print('ChatCubit: Marking messages as read for chat $chatId');
    emit(ChatLoading(chats: state.chats, messages: state.messages));
    try {
      final result = await markMessagesAsReadUseCase(chatId);
      result.fold(
            (failure) {
          print('ChatCubit: Error marking messages as read: ${failure.message}');
          emit(ChatError(
            message: _mapFailureToMessage(failure),
            chats: state.chats,
            messages: state.messages,
          ));
        },
            (_) {
          print('ChatCubit: Messages marked as read for chat $chatId');
          final updatedMessages = state.messages.map((message) {
            if (message.chatGroupId == chatId && !message.isRead && !message.isSentByUser) {
              return MessageEntity(
                id: message.id,
                chatGroupId: message.chatGroupId,
                senderId: message.senderId,
                content: message.content,
                emoji: message.emoji,
                createdAt: message.createdAt,
                isRead: true,
                isSentByUser: message.isSentByUser,
              );
            }
            return message;
          }).toList();
          final updatedChats = state.chats.map((chat) {
            if (chat.chatGroupId == chatId) {
              return ChatEntity(
                chatGroupId: chat.chatGroupId,
                partnerName: chat.partnerName,
                partnerId: chat.partnerId,
                partnerProfilePic: chat.partnerProfilePic,
                lastMessage: chat.lastMessage,
                unreadCount: 0,
              );
            }
            return chat;
          }).toList();
          print('ChatCubit: Updated messages isRead: ${updatedMessages.where((m) => m.chatGroupId == chatId).map((m) => m.isRead).toList()}');
          print('ChatCubit: Updated chats unreadCount: ${updatedChats.where((c) => c.chatGroupId == chatId).map((c) => c.unreadCount).toList()}');
          emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
        },
      );
    } catch (e) {
      print('ChatCubit: Unexpected error: $e');
      emit(ChatError(
        message: 'Unexpected error: $e',
        chats: state.chats,
        messages: state.messages,
      ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error: ${failure.message}';
      case AuthFailure:
        return 'Authentication Error: ${failure.message}';
      default:
        return 'Unexpected Error: ${failure.message}';
    }
  }

  Future<void> sendMessage(Map<String, dynamic> messageContent) async {
    print('ChatCubit: Sending message: $messageContent');
    emit(ChatLoading(chats: state.chats, messages: state.messages));
    try {
      final senderId = _currentUserId ?? (messageContent['senderId'] as String?);
      final content = messageContent['content'] as String?;
      final recipientId = messageContent['recipientId'] as String?;
      final receiverEmail = messageContent['receiverEmail'] as String?;

      if (senderId == null || content == null || (recipientId == null && receiverEmail == null)) {
        throw Exception('Missing required message fields');
      }

      final isNewChat = recipientId == null && receiverEmail != null;
      final chatGroupId = _currentChatGroupId;

      final completeMessageContent = {
        if (!isNewChat) 'chatGroupId': chatGroupId,
        'senderId': senderId,
        'content': content,
        if (recipientId != null) 'recipientId': recipientId,
        if (receiverEmail != null) 'receiverEmail': receiverEmail,
      };

      if (!isNewChat && chatGroupId != null) {
        final messageId = DateTime.now().millisecondsSinceEpoch.toString();
        _optimisticMessageId = messageId;
        final createdAt = DateTime.now();

        final newMessage = MessageEntity(
          id: messageId,
          chatGroupId: chatGroupId,
          senderId: senderId,
          content: content,
          createdAt: createdAt,
          isSentByUser: true,
          emoji: '',
          isRead: false,
        );
        final updatedMessages = [...state.messages, newMessage];

        final updatedChats = state.chats.map((chat) {
          if (chat.chatGroupId == chatGroupId) {
            return ChatEntity(
              chatGroupId: chat.chatGroupId,
              partnerName: chat.partnerName,
              partnerId: chat.partnerId,
              partnerProfilePic: chat.partnerProfilePic,
              lastMessage: LastMessageEntity(
                id: messageId,
                content: content,
                createdAt: createdAt,
                emoji: '',
                isSentByUser: true,
              ),
              unreadCount: chat.unreadCount,
            );
          }
          return chat;
        }).toList();

        emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
      }

      chatSocketService.sendMessage(completeMessageContent);
      print('ChatCubit: Message sent successfully');
    } catch (e) {
      print('ChatCubit: Error sending message: $e');
      _optimisticMessageId = null;
      emit(ChatError(
        message: 'Error sending message: $e',
        chats: state.chats,
        messages: state.messages,
      ));
    }
  }

  void initChatUpdates() {
    if (_isListenerInitialized) return;
    print('ChatCubit: Initializing chatUpdated listener');
    try {
      chatSocketService.onChatUpdated(_handleChatUpdated);
      _isListenerInitialized = true;
      print('ChatCubit: chatUpdated listener initialized');
    } catch (e) {
      print('ChatCubit: Error initializing chatUpdated listener: $e');
    }
  }

  void _handleChatUpdated(Map<String, dynamic> data) {
    print('ChatCubit: Received chatUpdated event: $data');
    try {
      final chatGroupId = data['chatGroupId'] as String;
      final partnerId = data['partnerId'] as String?;
      final partnerName = data['partnerName'] as String?;
      final partnerProfilePic = data['partnerProfilePic'] as String?;
      final unreadCount = (data['unreadCount'] as num?)?.toInt() ?? 0;
      final lastMessageData = data['lastMessage'] as Map<String, dynamic>?;

      if (lastMessageData == null) return;

      if (_currentChatGroupId == null) {
        _currentChatGroupId = chatGroupId;
      }

      final lastMessage = LastMessageEntity(
        id: lastMessageData['id'] as String,
        content: lastMessageData['content'] as String,
        createdAt: DateTime.parse(lastMessageData['createdAt'] as String),
        emoji: lastMessageData['emoji'] as String? ?? '',
        isSentByUser: lastMessageData['senderId'] == _currentUserId,
      );

      List<ChatEntity> updatedChats = state.chats;
      if (!state.chats.any((chat) => chat.chatGroupId == chatGroupId)) {
        updatedChats = [
          ...state.chats,
          ChatEntity(
            chatGroupId: chatGroupId,
            partnerId: partnerId ?? '',
            partnerName: partnerName ?? 'Unknown',
            partnerProfilePic: partnerProfilePic ?? '',
            lastMessage: lastMessage,
            unreadCount: unreadCount,
          ),
        ];
      } else {
        updatedChats = state.chats.map((chat) {
          if (chat.chatGroupId == chatGroupId) {
            return ChatEntity(
              chatGroupId: chat.chatGroupId,
              partnerName: partnerName ?? chat.partnerName,
              partnerId: partnerId ?? chat.partnerId,
              partnerProfilePic: partnerProfilePic ?? chat.partnerProfilePic,
              lastMessage: lastMessage,
              unreadCount: unreadCount,
            );
          }
          return chat;
        }).toList();
      }

      List<MessageEntity> updatedMessages = state.messages;
      if (_currentChatGroupId == chatGroupId) {
        final newMessage = MessageEntity(
          id: lastMessageData['id'] as String,
          chatGroupId: chatGroupId,
          senderId: lastMessageData['senderId'] as String,
          content: lastMessageData['content'] as String,
          createdAt: DateTime.parse(lastMessageData['createdAt'] as String),
          isSentByUser: lastMessageData['senderId'] == _currentUserId,
          emoji: lastMessageData['emoji'] as String? ?? '',
          isRead: lastMessageData['isRead'] as bool? ?? false,
        );
        if (_optimisticMessageId != null) {
          updatedMessages = state.messages.where((m) => m.id != _optimisticMessageId).toList();
        }
        updatedMessages = [...updatedMessages.where((m) => m.id != newMessage.id), newMessage];
        _optimisticMessageId = null;
      }

      emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
    } catch (e) {
      print('ChatCubit: Error handling chatUpdated: $e');
      _optimisticMessageId = null;
    }
  }

  @override
  Future<void> close() {
    print('ChatCubit: Closing and cleaning up listeners');
    _isListenerInitialized = false;
    _currentChatGroupId = null;
    _currentUserId = null;
    _optimisticMessageId = null;
    return super.close();
  }
}