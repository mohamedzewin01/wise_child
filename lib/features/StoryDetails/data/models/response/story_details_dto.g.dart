// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDetailsDto _$StoryDetailsDtoFromJson(Map<String, dynamic> json) =>
    StoryDetailsDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      story: json['story'] == null
          ? null
          : StoryDetails.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryDetailsDtoToJson(StoryDetailsDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'story': instance.story,
    };

StoryDetails _$StoryDetailsFromJson(Map<String, dynamic> json) => StoryDetails(
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
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  problem: json['problem'] == null
      ? null
      : Problem.fromJson(json['problem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoryDetailsToJson(StoryDetails instance) =>
    <String, dynamic>{
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

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
  categoryDescription: json['category_description'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'category_description': instance.categoryDescription,
  'created_at': instance.createdAt,
};

Problem _$ProblemFromJson(Map<String, dynamic> json) => Problem(
  problemId: (json['problem_id'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemDescription: json['problem_description'] as String?,
  problemCategoryId: (json['problem_category_id'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ProblemToJson(Problem instance) => <String, dynamic>{
  'problem_id': instance.problemId,
  'problem_title': instance.problemTitle,
  'problem_description': instance.problemDescription,
  'problem_category_id': instance.problemCategoryId,
  'created_at': instance.createdAt,
};
