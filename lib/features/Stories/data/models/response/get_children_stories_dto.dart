import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';

part 'get_children_stories_dto.g.dart';

@JsonSerializable()
class GetChildrenStoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "data")
  final Data? data;

  GetChildrenStoriesDto ({
    this.status,
    this.data,
  });

  factory GetChildrenStoriesDto.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenStoriesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenStoriesDtoToJson(this);
  }

  ChildrenStoriesEntity toEntity() => ChildrenStoriesEntity(
    status: status,
    data: data,
  );
}

@JsonSerializable()
class Data {
  @JsonKey(name: "storiesList")
  final List<StoriesList>? storiesList;

  Data ({
    this.storiesList,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataToJson(this);
  }
}

@JsonSerializable()
class StoriesList {
  @JsonKey(name: "children_stories_id")
  final int? childrenStoriesId;
  @JsonKey(name: "children_id")
  final int? childrenId;
  @JsonKey(name: "stories_id")
  final int? storiesId;
  @JsonKey(name: "creator_user_id")
  final String? creatorUserId;
  @JsonKey(name: "story_problem_id")
  final int? storyProblemId;
  @JsonKey(name: "story_creation_date")
  final String? storyCreationDate;
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "child_first_name")
  final String? childFirstName;
  @JsonKey(name: "child_last_name")
  final String? childLastName;
  @JsonKey(name: "child_gender")
  final String? childGender;
  @JsonKey(name: "child_dob")
  final String? childDob;
  @JsonKey(name: "child_image")
  final String? childImage;
  @JsonKey(name: "child_email")
  final dynamic? childEmail;
  @JsonKey(name: "siblings_count")
  final int? siblingsCount;
  @JsonKey(name: "friends_count")
  final int? friendsCount;
  @JsonKey(name: "child_created_at")
  final String? childCreatedAt;
  @JsonKey(name: "child_updated_at")
  final String? childUpdatedAt;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "user_first_name")
  final String? userFirstName;
  @JsonKey(name: "user_last_name")
  final String? userLastName;
  @JsonKey(name: "user_gender")
  final dynamic? userGender;
  @JsonKey(name: "user_age")
  final dynamic? userAge;
  @JsonKey(name: "user_email")
  final String? userEmail;
  @JsonKey(name: "user_role")
  final String? userRole;
  @JsonKey(name: "user_profile_image")
  final String? userProfileImage;
  @JsonKey(name: "user_created_at")
  final String? userCreatedAt;
  @JsonKey(name: "user_updated_at")
  final String? userUpdatedAt;
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;
  @JsonKey(name: "problem_created_at")
  final String? problemCreatedAt;

  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "story_description")
  final String? storyDescription;
  @JsonKey(name: "story_cover_image")
  final String? storyCoverImage;
  @JsonKey(name: "story_created_at")
  final String? storyCreatedAt;

  StoriesList ({
    this.childrenStoriesId,
    this.childrenId,
    this.storiesId,
    this.creatorUserId,
    this.storyProblemId,
    this.storyCreationDate,
    this.idChildren,
    this.childFirstName,
    this.childLastName,
    this.childGender,
    this.childDob,
    this.childImage,
    this.childEmail,
    this.siblingsCount,
    this.friendsCount,
    this.childCreatedAt,
    this.childUpdatedAt,
    this.userId,
    this.userFirstName,
    this.userLastName,
    this.userGender,
    this.userAge,
    this.userEmail,
    this.userRole,
    this.userProfileImage,
    this.userCreatedAt,
    this.userUpdatedAt,
    this.problemId,
    this.problemTitle,
    this.problemDescription,
    this.problemCreatedAt,
    this.storyId,
    this.storyTitle,
    this.storyDescription,
    this.storyCoverImage,
    this.storyCreatedAt,
  });

  factory StoriesList.fromJson(Map<String, dynamic> json) {
    return _$StoriesListFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesListToJson(this);
  }
}


