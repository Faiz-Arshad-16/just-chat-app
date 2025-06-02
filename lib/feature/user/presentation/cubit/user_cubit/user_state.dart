part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String? id;
  final String name;
  final String email;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isUpdated; // Added

  const UserLoaded({
    this.id,
    required this.name,
    required this.email,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.isUpdated = false, // Default to false
  });

  @override
  List<Object?> get props => [id, name, email, image, createdAt, updatedAt, isUpdated];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}