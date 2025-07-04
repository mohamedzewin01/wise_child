// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_kid_fav_image_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteKidFavImageRequest _$DeleteKidFavImageRequestFromJson(
  Map<String, dynamic> json,
) => DeleteKidFavImageRequest(
  idChildren: (json['id_children'] as num?)?.toInt(),
  storyId: (json['story_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$DeleteKidFavImageRequestToJson(
  DeleteKidFavImageRequest instance,
) => <String, dynamic>{
  'id_children': instance.idChildren,
  'story_id': instance.storyId,
};
