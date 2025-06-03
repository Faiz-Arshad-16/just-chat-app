import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/usecases/get_all_chats.dart';
import '../../domain/usecases/get_chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetAllChats getAllChatsUseCase;
  final GetChat getChatUseCase;

  ChatCubit({
    required this.getAllChatsUseCase,
    required this.getChatUseCase,
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