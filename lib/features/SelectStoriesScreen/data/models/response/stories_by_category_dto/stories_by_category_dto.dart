import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/response/user_stories_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/stories_by_category_entity.dart';
part 'stories_by_category_dto.g.dart';

@JsonSerializable()
class StoriesByCategoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "pages")
  final int? pages;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "stories")
  final List<StoriesCategory>? stories;

  StoriesByCategoryDto({
    this.status,
    this.message,
    this.page,
    this.limit,
    this.total,
    this.pages,
    this.count,
    this.stories,
  });

  factory StoriesByCategoryDto.fromJson(Map<String, dynamic> json) {
    return _$StoriesByCategoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesByCategoryDtoToJson(this);
  }

  StoriesByCategoryEntity toEntity() => StoriesByCategoryEntity(
    status: status,
    message: message,
    page: page,
    limit: limit,
    total: total,
    pages: pages,
    count: count,
    stories: stories,
  );
}

@JsonSerializable()
class StoriesCategory {
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
  @JsonKey(name: "problem")
  final Problem? problem;

  StoriesCategory({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.gender,
    this.ageGroup,
    this.isActive,
    this.createdAt,
    this.categoryId,
    this.problem,
  });

  factory StoriesCategory.fromJson(Map<String, dynamic> json) {
    return _$StoriesCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesCategoryToJson(this);
  }

}

@JsonSerializable()
class Problem {
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;
  @JsonKey(name: "problem_category_id")
  final int? problemCategoryId;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Problem({
    this.problemId,
    this.problemTitle,
    this.problemDescription,
    this.problemCategoryId,
    this.createdAt,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return _$ProblemFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProblemToJson(this);
  }
}
