// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_story_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveStoryRequest _$SaveStoryRequestFromJson(Map<String, dynamic> json) =>
    SaveStoryRequest(
      userId: json['user_id'] as String?,
      childrenId: (json['children_id'] as num?)?.toInt(),
      storiesId: (json['stories_id'] as num?)?.toInt(),
      problemId: (json['problem_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SaveStoryRequestToJson(SaveStoryRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'children_id': instance.childrenId,
      'stories_id': instance.storiesId,
      'problem_id': instance.problemId,
    };
