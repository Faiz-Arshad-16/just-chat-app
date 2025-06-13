import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/chat/data/data_sources/chat_socket_service/chat_socket_service.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/delete_message.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/get_all_chats.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/get_chat.dart';
import 'package:just_chat_app/feature/chat/domain/usecases/mark_messages_as_read.dart';
import 'package:just_chat_app/feature/chat/presentation/chat_cubit/chat_cubit.dart';
import 'package:just_chat_app/feature/user/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:just_chat_app/feature/user/domain/usecases/auth_usecases/update_user.dart';
import 'package:just_chat_app/feature/user/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:just_chat_app/feature/user/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:just_chat_app/core/di/main_injection_container.dart' as di;
import 'package:just_chat_app/feature/app/routes/on_generate_route.dart';
import 'package:just_chat_app/feature/app/theme/style.dart';
import 'feature/chat/domain/usecases/delete_chat.dart';
import 'feature/user/domain/usecases/auth_usecases/get_user.dart';
import 'feature/user/domain/usecases/auth_usecases/sign_in.dart';
import 'feature/user/domain/usecases/auth_usecases/sign_out.dart';
import 'feature/user/domain/usecases/auth_usecases/sign_up.dart';
import 'feature/user/presentation/pages/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize your GetIt dependencies
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit _authCubit;
  late final UserCubit _userCubit;
  late final ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(
      signInUseCase: di.sl<SignIn>(),
      signUpUseCase: di.sl<SignUp>(),
      signOutUseCase: di.sl<SignOut>(),
      getUserUseCase: di.sl<GetUser>(), chatSocketService: di.sl<ChatSocketService>(),
      // localDataSource: di.sl<AuthLocalDataSource>(),
    );
    _userCubit = UserCubit(
      getUserUseCase: di.sl<GetUser>(),
      localDataSource: di.sl<AuthLocalDataSource>(),
      updateUserUsecase: di.sl<UpdateUser>(),
    );
    _chatCubit = ChatCubit(
      getAllChatsUseCase: di.sl<GetAllChats>(),
      getChatUseCase: di.sl<GetChat>(),
      deleteChatUseCase: di.sl<DeleteChat>(),
      deleteMessageUseCase: di.sl<DeleteMessage>(),
      markMessagesAsReadUseCase: di.sl<MarkMessagesAsRead>(), chatSocketService: di.sl<ChatSocketService>(),
    );
  }

  @override
  void dispose() {
    _authCubit.close();
    _userCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<UserCubit>.value(value: _userCubit),
        BlocProvider<ChatCubit>.value(value: _chatCubit,),
      ],
      child: MaterialApp(
        title: 'Just Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.comfortaaTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sendMessageColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoute.route,
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
      ),
    );
  }
}
