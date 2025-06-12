// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelRequest _$UserModelRequestFromJson(Map<String, dynamic> json) =>
    UserModelRequest(
      id: json['id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      email: json['email'] as String?,
      role: json['role'] as String?,
      password: json['password'] as String?,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$UserModelRequestToJson(UserModelRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'age': instance.age,
      'email': instance.email,
      'role': instance.role,
      'password': instance.password,
      'profile_image': instance.profileImage,
    };
