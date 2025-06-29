// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileDto _$EditProfileDtoFromJson(Map<String, dynamic> json) =>
    EditProfileDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$EditProfileDtoToJson(EditProfileDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'updated_at': instance.updatedAt,
    };
