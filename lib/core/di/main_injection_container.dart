import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'; // Import for NetworkInfo

// Import the feature-specific DI initializer
import 'package:just_chat_app/feature/user/di/user_injection_container.dart' as user_di;

import '../../feature/chat/di/chat_injection_container.dart' as chat_di;

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ----------------------------------------------------
  // External/Core Dependencies (Registered ONLY ONCE)
  // ----------------------------------------------------

  // SharedPreferences (async initialization)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // HTTP Client
  sl.registerLazySingleton(() => http.Client());

  // Internet Connection Checker Plus
  // Use createInstance() as suggested by the package
  sl.registerLazySingleton(() => InternetConnection.createInstance());


  // ----------------------------------------------------
  // Feature-Specific DI Calls
  // ----------------------------------------------------

  // Call the initializer for the user feature, passing the common service locator instance
  await user_di.initUser(sl);

  // Initialize chat feature dependencies
  await chat_di.initChat(sl);
}