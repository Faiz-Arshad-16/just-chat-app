import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:just_chat_app/feature/chat/domain/usecases/delete_message.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/mark_messages_as_read.dart';
import '../../user/data/data_sources/local_data_source/auth_local_data_source.dart';
import '../data/data_sources/chat_remote_data_source/chat_remote_data_source.dart';
import '../data/data_sources/chat_remote_data_source/chat_remote_data_source_impl.dart';
import '../data/repository/chat_repository_impl.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/usecases/delete_chat.dart';
import '../domain/usecases/get_all_chats.dart';
import '../domain/usecases/get_chat.dart';
import '../presentation/chat_cubit/chat_cubit.dart';

Future<void> initChat(GetIt sl) async {
  // ----------------------------------------------------
  // Use Cases
  // ----------------------------------------------------
  sl.registerLazySingleton(() => GetAllChats(sl()));
  sl.registerLazySingleton(() => GetChat(sl()));
  sl.registerLazySingleton(() => DeleteChat(sl()));
  sl.registerLazySingleton(() => DeleteMessage(sl()));
  sl.registerLazySingleton(() => MarkMessagesAsRead(sl()));

  // ----------------------------------------------------
  // Cubit
  // ----------------------------------------------------
  sl.registerFactory(() => ChatCubit(
    getAllChatsUseCase: sl(),
    getChatUseCase: sl(),
    deleteChatUseCase: sl(),
    deleteMessageUseCase: sl(), markMessagesAsReadUseCase: sl(), chatSocketService: sl(),
  ));

  // ----------------------------------------------------
  // Repository
  // ----------------------------------------------------
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
    remoteDataSource: sl(),
  ));

  // ----------------------------------------------------
  // Data Sources
  // ----------------------------------------------------
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(
    client: sl<http.Client>(),
    baseUrl: 'https://just-chat-backend-production.up.railway.app',
    authLocalDataSource: sl<AuthLocalDataSource>(),
  ));
}