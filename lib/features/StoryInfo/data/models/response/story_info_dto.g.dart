// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryInfoDto _$StoryInfoDtoFromJson(Map<String, dynamic> json) => StoryInfoDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  story: json['story'] == null
      ? null
      : StoryInfo.fromJson(json['story'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoryInfoDtoToJson(StoryInfoDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'story': instance.story,
    };

StoryInfo _$StoryInfoFromJson(Map<String, dynamic> json) => StoryInfo(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  storyDescription: json['story_description'] as String?,
  gender: json['gender'] as String?,
  ageGroup: json['age_group'] as String?,
  isActive: json['is_active'] as bool?,
  createdAt: json['created_at'] as String?,
  category: json['category'] == null
      ? null
      : CategoryInfo.fromJson(json['category'] as Map<String, dynamic>),
  problem: json['problem'] == null
      ? null
      : ProblemInfo.fromJson(json['problem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoryInfoToJson(StoryInfo instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'story_description': instance.storyDescription,
  'gender': instance.gender,
  'age_group': instance.ageGroup,
  'is_active': instance.isActive,
  'created_at': instance.createdAt,
  'category': instance.category,
  'problem': instance.problem,
};

CategoryInfo _$CategoryInfoFromJson(Map<String, dynamic> json) => CategoryInfo(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
  categoryDescription: json['category_description'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$CategoryInfoToJson(CategoryInfo instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_description': instance.categoryDescription,
      'created_at': instance.createdAt,
    };

ProblemInfo _$ProblemInfoFromJson(Map<String, dynamic> json) => ProblemInfo(
  problemId: (json['problem_id'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemDescription: json['problem_description'] as String?,
  problemCategoryId: json['problem_category_id'],
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ProblemInfoToJson(ProblemInfo instance) =>
    <String, dynamic>{
      'problem_id': instance.problemId,
      'problem_title': instance.problemTitle,
      'problem_description': instance.problemDescription,
      'problem_category_id': instance.problemCategoryId,
      'created_at': instance.createdAt,
    };
