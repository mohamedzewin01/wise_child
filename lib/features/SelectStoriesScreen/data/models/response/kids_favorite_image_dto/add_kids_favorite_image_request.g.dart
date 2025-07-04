// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_kids_favorite_image_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddKidsFavoriteImageRequest _$AddKidsFavoriteImageRequestFromJson(
  Map<String, dynamic> json,
) => AddKidsFavoriteImageRequest(
  status: json['status'] as String?,
  message: json['message'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$AddKidsFavoriteImageRequestToJson(
  AddKidsFavoriteImageRequest instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'imageUrl': instance.imageUrl,
};
