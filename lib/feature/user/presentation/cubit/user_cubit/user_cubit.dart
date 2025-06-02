import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_chat_app/feature/user/domain/usecases/auth_usecases/update_user.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth_usecases/get_user.dart';
import '../../../data/data_sources/local_data_source/auth_local_data_source.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUser getUserUseCase;
  final AuthLocalDataSource localDataSource;
  final UpdateUser updateUserUsecase;

  UserCubit({
    required this.getUserUseCase,
    required this.localDataSource,
    required this.updateUserUsecase,
  }) : super(UserInitial());

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      final user = await localDataSource.getUser();
      emit(UserLoaded(
        id: user.id,
        name: user.name,
        email: user.email,
        image: user.image,
      ));
    } catch (e) {
      final result = await getUserUseCase(const NoParams());
      result.fold(
            (failure) => emit(UserError(message: failure.message)),
            (userEntity) => emit(UserLoaded(
          id: userEntity.id,
          name: userEntity.name,
          email: userEntity.email,
          image: userEntity.image,
        )),
      );
    }
  }

  // Future<void> updateUserProfile(String? name, String? image) async {
  //   emit(UserLoading());
  //   final result = await updateUserUsecase(UpdateUserParams(name: name, image: image));
  //   result.fold(
  //       (failure)=>emit(UserError(message: failure.message)),
  //       (updatedUser)=>emit(UserLoaded(
  //           id: updatedUser.id,
  //           name: updatedUser.name,
  //           email: updatedUser.email,
  //           image: updatedUser.image,
  //           createdAt: updatedUser.createdAt,
  //           updatedAt: updatedUser.updatedAt
  //       )
  //       )
  //   );
  // }

  Future<void> updateUserProfile(String? name, String? image) async {
    emit(UserLoading());
    try {
      final token = await localDataSource.getToken();
      print('Updating user profile: name=$name, token=$token');
      final result = await updateUserUsecase(UpdateUserParams(
        name: name,
        image: image,
      ));
      result.fold(
            (failure) {
          print('Update failed: ${failure.message}');
          emit(UserError(message: failure.message));
        },
            (updatedUser) async {
          print('Update successful: ${updatedUser.name}');
          // Retrieve ID from local cache
          String? id;
          try {
            final localUser = await localDataSource.getUser();
            id = localUser.id;
          } catch (e) {
            id = null; // Fallback
          }
          emit(UserLoaded(
            id: id,
            name: updatedUser.name,
            email: updatedUser.email,
            image: updatedUser.image,
            createdAt: updatedUser.createdAt,
            updatedAt: updatedUser.updatedAt,
            isUpdated: true,
          ));
        },
      );
    } catch (e) {
      print('Unexpected error in updateUserProfile: $e');
      emit(UserError(message: 'Unexpected error: $e'));
    }
  }

}