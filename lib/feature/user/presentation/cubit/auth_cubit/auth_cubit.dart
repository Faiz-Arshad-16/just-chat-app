import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth_usecases/get_user.dart';
import '../../../domain/usecases/auth_usecases/sign_in.dart';
import '../../../domain/usecases/auth_usecases/sign_out.dart';
import '../../../domain/usecases/auth_usecases/sign_up.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final GetUser getUserUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getUserUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getUserUseCase(const NoParams());
    result.fold(
          (failure) {
        emit(Unauthenticated());
      },
          (userEntity) {
        emit(Authenticated(token: userEntity.id, name: userEntity.name));
      },
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await signInUseCase(SignInParams(email: email, password: password));
    result.fold(
          (failure) {
        emit(AuthError(message: failure.message));
      },
          (userEntity) {
        emit(Authenticated(token: userEntity.id, name: userEntity.name));
      },
    );
  }

  Future<void> signup(String email, String password, String name) async {
    emit(AuthLoading());
    final result = await signUpUseCase(SignUpParams(
      name: name,
      email: email,
      password: password,
    ));
    result.fold(
          (failure) {
        emit(AuthError(message: failure.message));
      },
          (userEntity) {
        emit(Authenticated(token: userEntity.id, name: userEntity.name));
      },
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await signOutUseCase(const NoParams());
    result.fold(
          (failure) {
        emit(AuthError(message: failure.message));
      },
          (_) {
        emit(Unauthenticated());
      },
    );
  }
}