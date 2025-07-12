// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_children_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildrenUserDto _$GetChildrenUserDtoFromJson(Map<String, dynamic> json) =>
    GetChildrenUserDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => UserChildren.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetChildrenUserDtoToJson(GetChildrenUserDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'children': instance.children,
    };

UserChildren _$UserChildrenFromJson(Map<String, dynamic> json) => UserChildren(
  idChildren: (json['id_children'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  imageUrl: json['imageUrl'],
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
