// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_home_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHomeRequest _$GetHomeRequestFromJson(Map<String, dynamic> json) =>
    GetHomeRequest(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DataHome.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetHomeRequestToJson(GetHomeRequest instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

DataHome _$DataHomeFromJson(Map<String, dynamic> json) => DataHome(
  totalStories: (json['total_stories'] as num?)?.toInt(),
  activeStories: (json['active_stories'] as num?)?.toInt(),
  inactiveStories: (json['inactive_stories'] as num?)?.toInt(),
  topViewedStories: (json['top_viewed_stories'] as List<dynamic>?)
      ?.map((e) => TopViewedStories.fromJson(e as Map<String, dynamic>))
      .toList(),
  topInactiveStories: (json['top_inactive_stories'] as List<dynamic>?)
      ?.map((e) => TopInactiveStories.fromJson(e as Map<String, dynamic>))
      .toList(),
  storiesByGender: json['stories_by_gender'] == null
      ? null
      : StoriesByGender.fromJson(
          json['stories_by_gender'] as Map<String, dynamic>,
        ),
  storiesByAgeGroup: (json['stories_by_age_group'] as List<dynamic>?)
      ?.map((e) => StoriesByAgeGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  storiesWithZeroViews: (json['stories_with_zero_views'] as num?)?.toInt(),
  storiesByCategory: (json['stories_by_category'] as List<dynamic>?)
      ?.map((e) => StoriesByCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataHomeToJson(DataHome instance) => <String, dynamic>{
  'total_stories': instance.totalStories,
  'active_stories': instance.activeStories,
  'inactive_stories': instance.inactiveStories,
  'top_viewed_stories': instance.topViewedStories,
  'top_inactive_stories': instance.topInactiveStories,
  'stories_by_gender': instance.storiesByGender,
  'stories_by_age_group': instance.storiesByAgeGroup,
  'stories_with_zero_views': instance.storiesWithZeroViews,
  'stories_by_category': instance.storiesByCategory,
};

TopViewedStories _$TopViewedStoriesFromJson(Map<String, dynamic> json) =>
    TopViewedStories(
      storyId: (json['story_id'] as num?)?.toInt(),
      storyTitle: json['story_title'] as String?,
      viewsCount: (json['views_count'] as num?)?.toInt(),
      imageCover: json['image_cover'] as String?,
      ageGroup: json['age_group'] as String?,
      gender: json['gender'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
    );

Map<String, dynamic> _$TopViewedStoriesToJson(TopViewedStories instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'story_title': instance.storyTitle,
      'views_count': instance.viewsCount,
      'image_cover': instance.imageCover,
      'age_group': instance.ageGroup,
      'gender': instance.gender,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
    };

TopInactiveStories _$TopInactiveStoriesFromJson(Map<String, dynamic> json) =>
    TopInactiveStories(
      storyId: (json['story_id'] as num?)?.toInt(),
      storyTitle: json['story_title'] as String?,
      viewsCount: (json['views_count'] as num?)?.toInt(),
      imageCover: json['image_cover'] as String?,
      ageGroup: json['age_group'] as String?,
      gender: json['gender'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
    );

Map<String, dynamic> _$TopInactiveStoriesToJson(TopInactiveStories instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'story_title': instance.storyTitle,
      'views_count': instance.viewsCount,
      'image_cover': instance.imageCover,
      'age_group': instance.ageGroup,
      'gender': instance.gender,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
    };

StoriesByGender _$StoriesByGenderFromJson(Map<String, dynamic> json) =>
    StoriesByGender(
      Boy: (json['Boy'] as num?)?.toInt(),
      Girl: (json['Girl'] as num?)?.toInt(),
      Both: (json['Both'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoriesByGenderToJson(StoriesByGender instance) =>
    <String, dynamic>{
      'Boy': instance.Boy,
      'Girl': instance.Girl,
      'Both': instance.Both,
    };

StoriesByAgeGroup _$StoriesByAgeGroupFromJson(Map<String, dynamic> json) =>
    StoriesByAgeGroup(
      ageGroup: json['age_group'] as String?,
      count: (json['count'] as num?)?.toInt(),
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoriesByAgeGroupToJson(StoriesByAgeGroup instance) =>
    <String, dynamic>{
      'age_group': instance.ageGroup,
      'count': instance.count,
      'stories': instance.stories,
    };

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
);

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
};

StoriesByCategory _$StoriesByCategoryFromJson(Map<String, dynamic> json) =>
    StoriesByCategory(
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      categoryDescription: json['category_description'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoriesByCategoryToJson(StoriesByCategory instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_description': instance.categoryDescription,
      'count': instance.count,
    };
