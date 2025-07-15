import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';

part 'story_info_dto.g.dart';

@JsonSerializable()
class StoryInfoDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "story")
  final StoryInfo? story;

  StoryInfoDto ({
    this.status,
    this.message,
    this.story,
  });

  factory StoryInfoDto.fromJson(Map<String, dynamic> json) {
    return _$StoryInfoDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryInfoDtoToJson(this);
  }
  StoryInfoEntity toEntity() {
    return StoryInfoEntity(
      status: status,
      message: message,
      story: story,
    );
  }
}

@JsonSerializable()
class StoryInfo {
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
  @JsonKey(name: "category")
  final CategoryInfo? category;
  @JsonKey(name: "problem")
  final ProblemInfo? problem;

  StoryInfo ({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.gender,
    this.ageGroup,
    this.isActive,
    this.createdAt,
    this.category,
    this.problem,
  });

  factory StoryInfo.fromJson(Map<String, dynamic> json) {
    return _$StoryInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryInfoToJson(this);
  }
}

@JsonSerializable()
class CategoryInfo {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "created_at")
  final String? createdAt;

  CategoryInfo ({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.createdAt,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return _$CategoryInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoryInfoToJson(this);
  }
}

@JsonSerializable()
class ProblemInfo {
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;
  @JsonKey(name: "problem_category_id")
  final dynamic? problemCategoryId;
  @JsonKey(name: "created_at")
  final String? createdAt;

  ProblemInfo ({
    this.problemId,
    this.problemTitle,
    this.problemDescription,
    this.problemCategoryId,
    this.createdAt,
  });

  factory ProblemInfo.fromJson(Map<String, dynamic> json) {
    return _$ProblemInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProblemInfoToJson(this);
  }
}


