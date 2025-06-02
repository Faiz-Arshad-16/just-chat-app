import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? accessToken;
  final String? image;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.accessToken,
    this.image,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, email, accessToken, image, createdAt, updatedAt];
}