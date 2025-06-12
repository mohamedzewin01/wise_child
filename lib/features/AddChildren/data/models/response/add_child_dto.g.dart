// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildDto _$AddChildDtoFromJson(Map<String, dynamic> json) => AddChildDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  childId: json['child_id'] as String?,
);

Map<String, dynamic> _$AddChildDtoToJson(AddChildDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'child_id': instance.childId,
    };
