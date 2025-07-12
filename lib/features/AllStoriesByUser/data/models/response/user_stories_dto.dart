import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto/stories_by_category_dto.dart';

part 'user_stories_dto.g.dart';

@JsonSerializable()
class UserStoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "children_stories")
  final List<ChildrenStoriesData>? childrenStories;

  UserStoriesDto({this.status, this.message, this.childrenStories});

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
  @JsonKey(name: "playmate_name")
  final String? bestFriendName;
  @JsonKey(name: "stories")
  final List<StoriesHome>? stories;

  ChildrenStoriesData({
    this.childId,
    this.childName,
    this.gender,
    this.age,
    this.playmateGender,
    this.bestFriendName,
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
class StoriesHome {
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
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;

  StoriesHome({
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
    this.childId,
    this.problemId,
    this.problemTitle,
    this.problemDescription,
  });

  factory StoriesHome.fromJson(Map<String, dynamic> json) {
    return _$StoriesHomeFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesHomeToJson(this);
  }

  StoriesCategory toStoriesCategory() {
    return StoriesCategory(
      storyId: storyId,
      storyTitle: storyTitle,
      imageCover: imageCover,
      storyDescription: storyDescription,
      gender: gender,
      ageGroup: ageGroup,
      isActive: isActive,
      createdAt: createdAt,
      categoryId: categoryId,
      problem: Problem(
        problemId: problemId,
        problemTitle: problemTitle,
        problemDescription: problemDescription,
      ),
    );
  }
}
