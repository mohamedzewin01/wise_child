// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_by_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesByCategoryDto _$StoriesByCategoryDtoFromJson(
  Map<String, dynamic> json,
) => StoriesByCategoryDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  pages: (json['pages'] as num?)?.toInt(),
  count: (json['count'] as num?)?.toInt(),
  stories: (json['stories'] as List<dynamic>?)
      ?.map((e) => StoriesCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StoriesByCategoryDtoToJson(
  StoriesByCategoryDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'pages': instance.pages,
  'count': instance.count,
  'stories': instance.stories,
};

StoriesCategory _$StoriesCategoryFromJson(Map<String, dynamic> json) =>
    StoriesCategory(
      storyId: (json['story_id'] as num?)?.toInt(),
      storyTitle: json['story_title'] as String?,
      imageCover: json['image_cover'] as String?,
      storyDescription: json['story_description'] as String?,
      gender: json['gender'] as String?,
      ageGroup: json['age_group'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      problem: json['problem'] == null
          ? null
          : Problem.fromJson(json['problem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoriesCategoryToJson(StoriesCategory instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'story_title': instance.storyTitle,
      'image_cover': instance.imageCover,
      'story_description': instance.storyDescription,
      'gender': instance.gender,
      'age_group': instance.ageGroup,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'category_id': instance.categoryId,
      'problem': instance.problem,
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
