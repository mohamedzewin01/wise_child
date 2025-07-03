import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/StoryDetails/domain/entities/story_details_entities.dart';

part 'story_details_dto.g.dart';

@JsonSerializable()
class StoryDetailsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "story")
  final StoryDetails? story;

  StoryDetailsDto ({
    this.status,
    this.message,
    this.story,
  });

  factory StoryDetailsDto.fromJson(Map<String, dynamic> json) {
    return _$StoryDetailsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryDetailsDtoToJson(this);
  }

  StoryDetailsEntity toEntity() {
    return StoryDetailsEntity(
      status: status,
      message: message,
      story: story,
    );
  }
}

@JsonSerializable()
class StoryDetails {
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
  final Category? category;
  @JsonKey(name: "problem")
  final Problem? problem;

  // الجديد: حقل الصورة المفضلة
  @JsonKey(name: "favorite_image")
  final FavoriteImage? favoriteImage;

  StoryDetails ({
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
    this.favoriteImage,
  });

  factory StoryDetails.fromJson(Map<String, dynamic> json) {
    return _$StoryDetailsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryDetailsToJson(this);
  }
}

@JsonSerializable()
class Category {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Category ({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return _$CategoryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoryToJson(this);
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

  Problem ({
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


@JsonSerializable()
class FavoriteImage {
  @JsonKey(name: "id_favorite_image")
  final int? idFavoriteImage;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "created_at")
  final String? createdAt;

  FavoriteImage({
    this.idFavoriteImage,
    this.imageUrl,
    this.createdAt,
  });

  factory FavoriteImage.fromJson(Map<String, dynamic> json) {
    return _$FavoriteImageFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FavoriteImageToJson(this);
  }
}
