import 'package:json_annotation/json_annotation.dart';

part 'children_stories_model_dto.g.dart';

@JsonSerializable()
class ChildrenStoriesModelDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "data")
  final List<StoriesModeData>? data;

  ChildrenStoriesModelDto ({
    this.status,
    this.data,
  });

  factory ChildrenStoriesModelDto.fromJson(Map<String, dynamic> json) {
    return _$ChildrenStoriesModelDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildrenStoriesModelDtoToJson(this);
  }
}

@JsonSerializable()
class StoriesModeData {
  @JsonKey(name: "children_stories_id")
  final int? childrenStoriesId;
  @JsonKey(name: "children_id")
  final int? childrenId;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "children_story_created_at")
  final String? childrenStoryCreatedAt;
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
  @JsonKey(name: "story_created_at")
  final String? storyCreatedAt;
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;
  @JsonKey(name: "problem_created_at")
  final String? problemCreatedAt;

  StoriesModeData ({
    this.childrenStoriesId,
    this.childrenId,
    this.userId,
    this.childrenStoryCreatedAt,
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.gender,
    this.ageGroup,
    this.storyCreatedAt,
    this.problemId,
    this.problemTitle,
    this.problemDescription,
    this.problemCreatedAt,
  });

  factory StoriesModeData.fromJson(Map<String, dynamic> json) {
    return _$StoriesModeDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesModeDataToJson(this);
  }
}


