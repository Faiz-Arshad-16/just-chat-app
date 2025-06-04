import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/delete_chat.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/delete_message.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/mark_messages_as_read.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/last_message_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/usecases/get_all_chats.dart';
import '../../domain/usecases/get_chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetAllChats getAllChatsUseCase;
  final GetChat getChatUseCase;
  final DeleteChat deleteChatUseCase;
  final DeleteMessage deleteMessageUseCase;
  final MarkMessagesAsRead markMessagesAsReadUseCase;

  ChatCubit({
    required this.getAllChatsUseCase,
    required this.getChatUseCase,
    required this.deleteChatUseCase,
    required this.deleteMessageUseCase,
    required this.markMessagesAsReadUseCase,
  }) : super(ChatInitial());

  void fetchAllChats() async {
    print('ChatCubit: Fetching all chats');
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
          // Remove the deleted message locally
          final updatedMessages = state.messages.where((m) => m.id != id).toList();

          // Find the chatGroupId of the deleted message
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
              isSentByUser: false, emoji: '', isRead: false,
            ),
          );
          final chatGroupId = deletedMessage.chatGroupId;

          // Fetch the updated chat to get the new lastMessage
          final chatResult = await getChatUseCase(chatGroupId);
          chatResult.fold(
                (failure) {
              print('ChatCubit: Error fetching updated chat: ${failure.message}');
              // Fallback to local update with no lastMessage
              final updatedChats = state.chats.map((chat) {
                if (chat.chatGroupId == chatGroupId) {
                  return ChatEntity(
                    chatGroupId: chat.chatGroupId,
                    partnerName: chat.partnerName,
                    partnerProfilePic: chat.partnerProfilePic,
                    lastMessage: null, unreadCount: chat.unreadCount,
                  );
                }
                return chat;
              }).toList();
              emit(ChatLoaded(chats: updatedChats, messages: updatedMessages));
            },
                (fetchedMessages) {
              // Update the chats list with the fetched chat's lastMessage
              final updatedChats = state.chats.map((chat) {
                if (chat.chatGroupId == chatGroupId) {
                  final newLastMessage = fetchedMessages.isNotEmpty
                      ? fetchedMessages.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b)
                      : null;
                  return ChatEntity(
                    chatGroupId: chat.chatGroupId,
                    partnerName: chat.partnerName,
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
          // Update messages to set isRead: true for non-user messages
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

          // Update chats to set unreadCount: 0
          final updatedChats = state.chats.map((chat) {
            if (chat.chatGroupId == chatId) {
              return ChatEntity(
                chatGroupId: chat.chatGroupId,
                partnerName: chat.partnerName,
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
}