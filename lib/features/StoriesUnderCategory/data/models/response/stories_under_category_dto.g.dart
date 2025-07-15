// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_under_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesUnderCategoryDto _$StoriesUnderCategoryDtoFromJson(
  Map<String, dynamic> json,
) => StoriesUnderCategoryDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoriesUnderCategoryDtoToJson(
  StoriesUnderCategoryDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'category': instance.category,
};

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
  stories: (json['stories'] as List<dynamic>?)
      ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'stories': instance.stories,
};

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  storyDescription: json['story_description'] as String?,
  problemId: (json['problem_id'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  gender: json['gender'] as String?,
  ageGroup: json['age_group'] as String?,
  isActive: json['is_active'] as bool?,
  bestFriendGender: json['best_friend_gender'] as String?,
  viewsCount: (json['views_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'story_description': instance.storyDescription,
  'problem_id': instance.problemId,
  'created_at': instance.createdAt,
  'gender': instance.gender,
  'age_group': instance.ageGroup,
  'is_active': instance.isActive,
  'best_friend_gender': instance.bestFriendGender,
  'views_count': instance.viewsCount,
};
