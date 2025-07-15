import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';

part 'stories_under_category_dto.g.dart';

@JsonSerializable()
class StoriesUnderCategoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "category")
  final Category? category;

  StoriesUnderCategoryDto ({
    this.status,
    this.message,
    this.category,
  });

  factory StoriesUnderCategoryDto.fromJson(Map<String, dynamic> json) {
    return _$StoriesUnderCategoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesUnderCategoryDtoToJson(this);
  }
  StoriesUnderCategoryEntity toEntity() {
    return StoriesUnderCategoryEntity(
      status: status,
      message: message,
      category: category,
    );
  }
}

@JsonSerializable()
class Category {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "stories")
  final List<Stories>? stories;

  Category ({
    this.categoryId,
    this.categoryName,
    this.stories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return _$CategoryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoryToJson(this);
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
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "is_active")
  final bool? isActive;
  @JsonKey(name: "best_friend_gender")
  final String? bestFriendGender;
  @JsonKey(name: "views_count")
  final int? viewsCount;

  Stories ({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.problemId,
    this.createdAt,
    this.gender,
    this.ageGroup,
    this.isActive,
    this.bestFriendGender,
    this.viewsCount,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return _$StoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesToJson(this);
  }
}


