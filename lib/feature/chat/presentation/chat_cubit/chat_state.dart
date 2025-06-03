part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  final List<ChatEntity> chats;
  final List<MessageEntity> messages;

  const ChatState({this.chats = const [], this.messages = const []});

  @override
  List<Object?> get props => [chats, messages];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  const ChatLoading({super.chats, super.messages});
}

class ChatLoaded extends ChatState {
  const ChatLoaded({super.chats, super.messages});
}

class ChatError extends ChatState {
  final String message;

  const ChatError({
    required this.message,
    super.chats,
    super.messages,
  });

  @override
  List<Object?> get props => [message, chats, messages];
}