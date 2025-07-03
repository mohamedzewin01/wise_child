// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDetailsRequest _$StoryDetailsRequestFromJson(Map<String, dynamic> json) =>
    StoryDetailsRequest(
      userId: json['user_id'] as String?,
      storyId: (json['story_id'] as num?)?.toInt(),
      idChildren: (json['id_children'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoryDetailsRequestToJson(
  StoryDetailsRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'story_id': instance.storyId,
  'id_children': instance.idChildren,
};
