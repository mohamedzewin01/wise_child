// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_stories_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildrenStoriesModelDto _$ChildrenStoriesModelDtoFromJson(
  Map<String, dynamic> json,
) => ChildrenStoriesModelDto(
  status: json['status'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => StoriesModeData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChildrenStoriesModelDtoToJson(
  ChildrenStoriesModelDto instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

StoriesModeData _$StoriesModeDataFromJson(Map<String, dynamic> json) =>
    StoriesModeData(
      childrenStoriesId: (json['children_stories_id'] as num?)?.toInt(),
      childrenId: (json['children_id'] as num?)?.toInt(),
      userId: json['user_id'] as String?,
      childrenStoryCreatedAt: json['children_story_created_at'] as String?,
      storyId: (json['story_id'] as num?)?.toInt(),
      storyTitle: json['story_title'] as String?,
      imageCover: json['image_cover'] as String?,
      storyDescription: json['story_description'] as String?,
      gender: json['gender'] as String?,
      ageGroup: json['age_group'] as String?,
      storyCreatedAt: json['story_created_at'] as String?,
      problemId: (json['problem_id'] as num?)?.toInt(),
      problemTitle: json['problem_title'] as String?,
      problemDescription: json['problem_description'] as String?,
      problemCreatedAt: json['problem_created_at'] as String?,
    );

Map<String, dynamic> _$StoriesModeDataToJson(StoriesModeData instance) =>
    <String, dynamic>{
      'children_stories_id': instance.childrenStoriesId,
      'children_id': instance.childrenId,
      'user_id': instance.userId,
      'children_story_created_at': instance.childrenStoryCreatedAt,
      'story_id': instance.storyId,
      'story_title': instance.storyTitle,
      'image_cover': instance.imageCover,
      'story_description': instance.storyDescription,
      'gender': instance.gender,
      'age_group': instance.ageGroup,
      'story_created_at': instance.storyCreatedAt,
      'problem_id': instance.problemId,
      'problem_title': instance.problemTitle,
      'problem_description': instance.problemDescription,
      'problem_created_at': instance.problemCreatedAt,
    };
