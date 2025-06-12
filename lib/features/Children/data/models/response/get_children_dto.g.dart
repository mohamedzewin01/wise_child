// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_children_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildrenDto _$GetChildrenDtoFromJson(Map<String, dynamic> json) =>
    GetChildrenDto(
      status: json['status'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Children.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetChildrenDtoToJson(GetChildrenDto instance) =>
    <String, dynamic>{'status': instance.status, 'children': instance.children};

Children _$ChildrenFromJson(Map<String, dynamic> json) => Children(
  idChildren: (json['id_children'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  imageUrl: json['imageUrl'] as String?,
  emailChildren: json['email_children'],
  userId: json['user_id'] as String?,
  siblingsCount: (json['siblings_count'] as num?)?.toInt(),
  friendsCount: (json['friends_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChildrenToJson(Children instance) => <String, dynamic>{
  'id_children': instance.idChildren,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'date_of_birth': instance.dateOfBirth,
  'imageUrl': instance.imageUrl,
  'email_children': instance.emailChildren,
  'user_id': instance.userId,
  'siblings_count': instance.siblingsCount,
  'friends_count': instance.friendsCount,
};
