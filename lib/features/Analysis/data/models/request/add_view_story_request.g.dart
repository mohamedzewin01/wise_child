// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_view_story_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddViewStoryRequest _$AddViewStoryRequestFromJson(Map<String, dynamic> json) =>
    AddViewStoryRequest(
      storyId: (json['story_id'] as num?)?.toInt(),
      childId: (json['child_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddViewStoryRequestToJson(
  AddViewStoryRequest instance,
) => <String, dynamic>{
  'story_id': instance.storyId,
  'child_id': instance.childId,
};
