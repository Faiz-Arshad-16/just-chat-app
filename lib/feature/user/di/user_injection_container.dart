import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/data_sources/local_data_source/auth_local_data_source.dart';
import '../data/data_sources/local_data_source/auth_local_data_source_impl.dart';
import '../data/data_sources/remote_data_source/auth_remote_data_source.dart';
import '../data/data_sources/remote_data_source/auth_remote_data_source_impl.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/usecases/auth_usecases/get_user.dart';
import '../domain/usecases/auth_usecases/sign_in.dart';
import '../domain/usecases/auth_usecases/sign_out.dart';
import '../domain/usecases/auth_usecases/sign_up.dart';
import '../../../core/network/network_info.dart';
import '../domain/usecases/auth_usecases/update_user.dart';

/// Initializes dependencies for the user feature.
Future<void> initUser(GetIt sl) async {
  // ----------------------------------------------------
  // Use Cases
  // ----------------------------------------------------
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));

  // ----------------------------------------------------
  // Repository
  // ----------------------------------------------------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    networkInfo: sl(),
  ));

  // ----------------------------------------------------
  // Data Sources
  // ----------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
    client: sl<http.Client>(),
    localDataSource: sl(),
  ));

  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
    sharedPreferences: sl<SharedPreferences>(),
  ));

  // ----------------------------------------------------
  // Core
  // ----------------------------------------------------
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}