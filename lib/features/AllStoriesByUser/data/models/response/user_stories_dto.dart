import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';

part 'user_stories_dto.g.dart';

@JsonSerializable()
class UserStoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "children_stories")
  final List<ChildrenStoriesData>? childrenStories;

  UserStoriesDto ({
    this.status,
    this.message,
    this.childrenStories,
  });

  factory UserStoriesDto.fromJson(Map<String, dynamic> json) {
    return _$UserStoriesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserStoriesDtoToJson(this);
  }
  UserStoriesEntity toEntity() {
    return UserStoriesEntity(
      status: status,
      message: message,
      childrenStories: childrenStories,
    );
  }
}

@JsonSerializable()
class ChildrenStoriesData {
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "child_name")
  final String? childName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age")
  final int? age;
  @JsonKey(name: "playmate_gender")
  final String? playmateGender;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "stories")
  final List<Stories>? stories;

  ChildrenStoriesData ({
    this.childId,
    this.childName,
    this.gender,
    this.age,
    this.playmateGender,
    this.imageUrl,
    this.stories,
  });

  factory ChildrenStoriesData.fromJson(Map<String, dynamic> json) {
    return _$ChildrenStoriesDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildrenStoriesDataToJson(this);
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
  @JsonKey(name: "story_description")
  final String? storyDescription;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "is_active")
  final bool? isActive;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "best_friend_gender")
  final String? bestFriendGender;
  @JsonKey(name: "child_name")
  final String? childName;

  Stories ({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.gender,
    this.ageGroup,
    this.isActive,
    this.createdAt,
    this.categoryId,
    this.categoryName,
    this.bestFriendGender,
    this.childName,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return _$StoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesToJson(this);
  }
}


