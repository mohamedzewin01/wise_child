// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserDetailsDto _$GetUserDetailsDtoFromJson(Map<String, dynamic> json) =>
    GetUserDetailsDto(
      status: json['status'] as String?,
      user: json['user'] == null
          ? null
          : UserDetail.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetUserDetailsDtoToJson(GetUserDetailsDto instance) =>
    <String, dynamic>{'status': instance.status, 'user': instance.user};

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
  id: json['id'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  profileImage: json['profile_image'] as String?,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => UserChildren.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'profile_image': instance.profileImage,
      'children': instance.children,
    };

UserChildren _$UserChildrenFromJson(Map<String, dynamic> json) => UserChildren(
  idChildren: (json['id_children'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$UserChildrenToJson(UserChildren instance) =>
    <String, dynamic>{
      'id_children': instance.idChildren,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'imageUrl': instance.imageUrl,
    };
