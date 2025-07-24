import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/ChildStories/domain/entities/child_stories_entity.dart';

part 'get_child_stories_dto.g.dart';

@JsonSerializable()
class GetChildStoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "child")
  final Child? child;
  @JsonKey(name: "message")
  final Child? message;

  GetChildStoriesDto ({
    this.status,
    this.message,
    this.child,
  });

  factory GetChildStoriesDto.fromJson(Map<String, dynamic> json) {
    return _$GetChildStoriesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildStoriesDtoToJson(this);
  }
  ChildStoriesEntity toEntity() {
    return ChildStoriesEntity(
      status: status,
      message: message,
      child: child,
    );
  }
}

@JsonSerializable()
class Child {
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "date_of_birth")
  final String? dateOfBirth;
  @JsonKey(name: "image")
  final dynamic? image;
  @JsonKey(name: "siblings_count")
  final int? siblingsCount;
  @JsonKey(name: "friends_count")
  final int? friendsCount;
  @JsonKey(name: "stories")
  final List<Stories>? stories;

  Child ({
    this.childId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.image,
    this.siblingsCount,
    this.friendsCount,
    this.stories,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return _$ChildFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildToJson(this);
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
  final int? isActive;
  @JsonKey(name: "category_id")
  final int? categoryId;
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
    this.categoryId,
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


