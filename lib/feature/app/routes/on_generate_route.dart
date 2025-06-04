// lib/feature/app/routes/on_generate_route.dart

import 'package:flutter/material.dart';
import 'package:just_chat_app/feature/chat/domain/entity/chat_entity.dart';
// Corrected import path for SplashScreen if it moved or was always there.
import 'package:just_chat_app/feature/user/presentation/pages/splash_screen.dart'; // Ensure this path is correct

import 'package:just_chat_app/feature/chat/presentation/pages/chat_coversation_page.dart'; // Corrected import
import 'package:just_chat_app/feature/chat/presentation/pages/home_page.dart'; // Corrected import (assuming home page is in chat feature)
import 'package:just_chat_app/feature/user/presentation/pages/profile_page.dart'; // Corrected import
import 'package:just_chat_app/feature/user/presentation/pages/login_page.dart'; // Corrected import
import 'package:just_chat_app/feature/user/presentation/pages/signup_page.dart'; // Corrected import

import '../const/chat_list_model.dart'; // Ensure this path is correct

class PageConst {
  static const String splash = "/";
  static const String login = "login";
  static const String signUp = "signUp";
  static const String home = "home";
  static const String profile = "profile";
  static const String chats = "chats";
}

class OnGenerateRoute {
  // static Route? route(RouteSettings settings) {
  //   final name = settings.name;
  //   final args = settings.arguments;
  //
  //   switch (name) {
  //     case PageConst.splash:
  //     // When the initialRoute of MaterialApp is set to '/',
  //     // it will build this SplashScreen first.
  //     // The SplashScreen itself handles the authentication check and subsequent navigation.
  //       return MaterialPageRoute(builder: (_) => const SplashScreen());
  //     case PageConst.login:
  //       return MaterialPageRoute(builder: (_) => const LoginPage()); // Added const
  //     case PageConst.signUp:
  //       return MaterialPageRoute(builder: (_) => const SignupPage()); // Added const
  //     case PageConst.profile:
  //       return MaterialPageRoute(builder: (_) => const ProfilePage()); // Added const
  //     case PageConst.home:
  //       return MaterialPageRoute(builder: (_) => const HomePage()); // Added const
  //     case PageConst.chats:
  //       if (args is ChatEntity) {
  //         return MaterialPageRoute(builder: (_) => ChatConversationPage(chat: args));
  //       } else {
  //         return MaterialPageRoute(builder: (_) => const ErrorPage()); // Added const
  //       }
  //     default:
  //       return MaterialPageRoute(builder: (_) => const ErrorPage()); // Handle unknown routes, Added const
  //   }
  // }
  static Route? route(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;

    Widget page;

    switch (name) {
      case PageConst.splash:
        page = const SplashScreen();
        break;
      case PageConst.login:
        page = const LoginPage();
        break;
      case PageConst.signUp:
        page = const SignupPage();
        break;
      case PageConst.profile:
        page = const ProfilePage();
        break;
      case PageConst.home:
        page = const HomePage();
        break;
      case PageConst.chats:
        if (args is ChatEntity) {
          page = ChatConversationPage(chat: args);
        } else {
          page = const ErrorPage();
        }
        break;
      default:
        page = const ErrorPage();
    }

    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold( // Added const
      body: Center(
        child: Text("Error Page"),
      ),
    );
  }
}