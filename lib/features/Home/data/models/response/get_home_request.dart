import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Home/domain/entities/home_entity.dart';

part 'get_home_request.g.dart';

@JsonSerializable()
class GetHomeRequest {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final DataHome? data;

  GetHomeRequest ({
    this.status,
    this.message,
    this.data,
  });

  factory GetHomeRequest.fromJson(Map<String, dynamic> json) {
    return _$GetHomeRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetHomeRequestToJson(this);
  }
  GetHomeEntity toEntity() {
    return GetHomeEntity(
      status: status,
      message: message,
      data: data,
    );
  }
}

@JsonSerializable()
class DataHome {
  @JsonKey(name: "total_stories")
  final int? totalStories;
  @JsonKey(name: "active_stories")
  final int? activeStories;
  @JsonKey(name: "inactive_stories")
  final int? inactiveStories;
  @JsonKey(name: "top_viewed_stories")
  final List<TopViewedStories>? topViewedStories;
  @JsonKey(name: "top_inactive_stories")
  final List<TopInactiveStories>? topInactiveStories;
  @JsonKey(name: "stories_by_gender")
  final StoriesByGender? storiesByGender;
  @JsonKey(name: "stories_by_age_group")
  final List<StoriesByAgeGroup>? storiesByAgeGroup;
  @JsonKey(name: "stories_with_zero_views")
  final int? storiesWithZeroViews;
  @JsonKey(name: "stories_by_category")
  final List<StoriesByCategory>? storiesByCategory;

  DataHome ({
    this.totalStories,
    this.activeStories,
    this.inactiveStories,
    this.topViewedStories,
    this.topInactiveStories,
    this.storiesByGender,
    this.storiesByAgeGroup,
    this.storiesWithZeroViews,
    this.storiesByCategory,
  });

  factory DataHome.fromJson(Map<String, dynamic> json) {
    return _$DataHomeFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataHomeToJson(this);
  }
}

@JsonSerializable()
class TopViewedStories {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "views_count")
  final int? viewsCount;
  @JsonKey(name: "image_cover")
  final String? imageCover;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;

  TopViewedStories ({
    this.storyId,
    this.storyTitle,
    this.viewsCount,
    this.imageCover,
    this.ageGroup,
    this.gender,
    this.categoryId,
    this.categoryName,
  });

  factory TopViewedStories.fromJson(Map<String, dynamic> json) {
    return _$TopViewedStoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TopViewedStoriesToJson(this);
  }
}

@JsonSerializable()
class TopInactiveStories {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "views_count")
  final int? viewsCount;
  @JsonKey(name: "image_cover")
  final String? imageCover;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;

  TopInactiveStories ({
    this.storyId,
    this.storyTitle,
    this.viewsCount,
    this.imageCover,
    this.ageGroup,
    this.gender,
    this.categoryId,
    this.categoryName,
  });

  factory TopInactiveStories.fromJson(Map<String, dynamic> json) {
    return _$TopInactiveStoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TopInactiveStoriesToJson(this);
  }
}

@JsonSerializable()
class StoriesByGender {
  @JsonKey(name: "Boy")
  final int? Boy;
  @JsonKey(name: "Girl")
  final int? Girl;
  @JsonKey(name: "Both")
  final int? Both;

  StoriesByGender ({
    this.Boy,
    this.Girl,
    this.Both,
  });

  factory StoriesByGender.fromJson(Map<String, dynamic> json) {
    return _$StoriesByGenderFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesByGenderToJson(this);
  }
}

@JsonSerializable()
class StoriesByAgeGroup {
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "stories")
  final List<Stories>? stories;

  StoriesByAgeGroup ({
    this.ageGroup,
    this.count,
    this.stories,
  });

  factory StoriesByAgeGroup.fromJson(Map<String, dynamic> json) {
    return _$StoriesByAgeGroupFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesByAgeGroupToJson(this);
  }
}

@JsonSerializable()
class Stories {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "image_cover")
  final String? imageCover;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;

  Stories ({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.categoryId,
    this.categoryName,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return _$StoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesToJson(this);
  }
}

@JsonSerializable()
class StoriesByCategory {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "count")
  final int? count;

  StoriesByCategory ({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.count,
  });

  factory StoriesByCategory.fromJson(Map<String, dynamic> json) {
    return _$StoriesByCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesByCategoryToJson(this);
  }
}


