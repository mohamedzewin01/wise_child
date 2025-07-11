// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStoriesDto _$UserStoriesDtoFromJson(Map<String, dynamic> json) =>
    UserStoriesDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      childrenStories: (json['children_stories'] as List<dynamic>?)
          ?.map((e) => ChildrenStoriesData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserStoriesDtoToJson(UserStoriesDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'children_stories': instance.childrenStories,
    };

ChildrenStoriesData _$ChildrenStoriesDataFromJson(Map<String, dynamic> json) =>
    ChildrenStoriesData(
      childId: (json['child_id'] as num?)?.toInt(),
      childName: json['child_name'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      playmateGender: json['playmate_gender'] as String?,
      imageUrl: json['image_url'] as String?,
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChildrenStoriesDataToJson(
  ChildrenStoriesData instance,
) => <String, dynamic>{
  'child_id': instance.childId,
  'child_name': instance.childName,
  'gender': instance.gender,
  'age': instance.age,
  'playmate_gender': instance.playmateGender,
  'image_url': instance.imageUrl,
  'stories': instance.stories,
};

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  storyDescription: json['story_description'] as String?,
  gender: json['gender'] as String?,
  ageGroup: json['age_group'] as String?,
  isActive: json['is_active'] as bool?,
  createdAt: json['created_at'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
  bestFriendGender: json['best_friend_gender'] as String?,
  childName: json['child_name'] as String?,
);

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'story_description': instance.storyDescription,
  'gender': instance.gender,
  'age_group': instance.ageGroup,
  'is_active': instance.isActive,
  'created_at': instance.createdAt,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'best_friend_gender': instance.bestFriendGender,
  'child_name': instance.childName,
};
