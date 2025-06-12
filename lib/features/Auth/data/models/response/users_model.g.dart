// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersModelDto _$UsersModelDtoFromJson(Map<String, dynamic> json) =>
    UsersModelDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : NewUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UsersModelDtoToJson(UsersModelDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'user': instance.user,
    };

NewUser _$NewUserFromJson(Map<String, dynamic> json) => NewUser(
  json['first_name'] as String?,
  json['last_name'] as String?,
  json['email'] as String?,
  json['id'] as String?,
  json['gender'] as String?,
  (json['age'] as num?)?.toInt(),
  json['role'] as String?,
  json['profile_image'] as String?,
  json['created_at'] as String?,
);

Map<String, dynamic> _$NewUserToJson(NewUser instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'age': instance.age,
  'email': instance.email,
  'role': instance.role,
  'profile_image': instance.profileImage,
  'created_at': instance.createdAt,
};
