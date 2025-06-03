import '../../../../core/errors/exceptions.dart';
import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.accessToken,
    super.image,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      accessToken: json['access_token'] as String,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  factory UserModel.fromProfileJson(Map<String, dynamic> json, {String? accessToken, String? id}) {
    final userData = json['data'] as Map<String, dynamic>;

    // Log raw data for debugging
    print('fromProfileJson data: $userData');

    // Handle required fields with null checks
    final name = userData['name'] as String? ?? (throw ServerException('Name is missing or null in response'));
    final email = userData['email'] as String? ?? (throw ServerException('Email is missing or null in response'));
    final createdAtString = userData['createdAt'] as String?;
    if (createdAtString == null) {
      throw ServerException('CreatedAt is missing or null in response');
    }

    return UserModel(
      id: id ?? '', // Use provided ID or empty string
      name: name,
      email: email,
      accessToken: accessToken ?? '',
      image: userData['image'] as String?,
      createdAt: DateTime.parse(createdAtString),
      updatedAt: userData['updatedAt'] != null
          ? DateTime.parse(userData['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'access_token': accessToken,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      image: entity.image,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}