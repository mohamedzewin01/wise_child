// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_child_stories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildStoriesDto _$GetChildStoriesDtoFromJson(Map<String, dynamic> json) =>
    GetChildStoriesDto(
      status: json['status'] as String?,
      message: json['message'] == null
          ? null
          : Child.fromJson(json['message'] as Map<String, dynamic>),
      child: json['child'] == null
          ? null
          : Child.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetChildStoriesDtoToJson(GetChildStoriesDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'child': instance.child,
      'message': instance.message,
    };

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
  childId: (json['child_id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  image: json['image'],
  siblingsCount: (json['siblings_count'] as num?)?.toInt(),
  friendsCount: (json['friends_count'] as num?)?.toInt(),
  stories: (json['stories'] as List<dynamic>?)
      ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
  'child_id': instance.childId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'date_of_birth': instance.dateOfBirth,
  'image': instance.image,
  'siblings_count': instance.siblingsCount,
  'friends_count': instance.friendsCount,
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
  isActive: (json['is_active'] as num?)?.toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
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
  'category_id': instance.categoryId,
  'best_friend_gender': instance.bestFriendGender,
  'views_count': instance.viewsCount,
};
