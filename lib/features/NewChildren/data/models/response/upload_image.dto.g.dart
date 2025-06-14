// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_image.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImageDto _$UploadImageDtoFromJson(Map<String, dynamic> json) =>
    UploadImageDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$UploadImageDtoToJson(UploadImageDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'imageUrl': instance.imageUrl,
    };
