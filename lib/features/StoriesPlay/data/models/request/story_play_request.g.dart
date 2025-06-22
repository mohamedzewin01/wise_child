// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_play_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryPlayRequestModel _$StoryPlayRequestModelFromJson(
  Map<String, dynamic> json,
) => StoryPlayRequestModel(
  storyId: (json['story_id'] as num?)?.toInt(),
  childName: json['child_name'] as String?,
);

Map<String, dynamic> _$StoryPlayRequestModelToJson(
  StoryPlayRequestModel instance,
) => <String, dynamic>{
  'story_id': instance.storyId,
  'child_name': instance.childName,
};
