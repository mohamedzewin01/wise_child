import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/ChildDetailsPage/domain/entities/children_details_entity.dart';

part 'children_details_dto.g.dart';

@JsonSerializable()
class ChildrenDetailsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "child")
  final ChildDetails? child;

  ChildrenDetailsDto({this.status, this.child});

  factory ChildrenDetailsDto.fromJson(Map<String, dynamic> json) {
    return _$ChildrenDetailsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildrenDetailsDtoToJson(this);
  }

  ChildrenDetailsEntity toEntity() =>
      ChildrenDetailsEntity(child: child, status: status);
}

@JsonSerializable()
class ChildDetails {
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "date_of_birth")
  final String? dateOfBirth;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "email_children")
  final String? emailChildren;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "siblings_count")
  final int? siblingsCount;
  @JsonKey(name: "friends_count")
  final int? friendsCount;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "stories")
  final List<Stories>? stories;
  @JsonKey(name: "friends")
  final List<Friends>? friends;
  @JsonKey(name: "siblings")
  final List<Siblings>? siblings;
  @JsonKey(name: "best_playmate")
  final BestPlaymate? bestPlaymate;

  ChildDetails({
    this.idChildren,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
    this.emailChildren,
    this.userId,
    this.siblingsCount,
    this.friendsCount,
    this.createdAt,
    this.updatedAt,
    this.stories,
    this.friends,
    this.siblings,
    this.bestPlaymate,
  });

  factory ChildDetails.fromJson(Map<String, dynamic> json) {
    return _$ChildDetailsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildDetailsToJson(this);
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
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "is_active")
  final int? isActive;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Stories({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.problemId,
    this.gender,
    this.ageGroup,
    this.categoryId,
    this.isActive,
    this.createdAt,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return _$StoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesToJson(this);
  }
}

@JsonSerializable()
class Friends {
  @JsonKey(name: "id_friend")
  final int? idFriend;
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "friend_name")
  final String? friendName;
  @JsonKey(name: "friend_age")
  final int? friendAge;
  @JsonKey(name: "friend_gender")
  final String? friendGender;
  @JsonKey(name: "friend_contact")
  final int? friendContact;

  Friends({
    this.idFriend,
    this.childId,
    this.friendName,
    this.friendAge,
    this.friendGender,
    this.friendContact,
  });

  factory Friends.fromJson(Map<String, dynamic> json) {
    return _$FriendsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FriendsToJson(this);
  }
}

@JsonSerializable()
class Siblings {
  @JsonKey(name: "id_sibling")
  final int? idSibling;
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "sibling_name")
  final String? siblingName;
  @JsonKey(name: "sibling_age")
  final int? siblingAge;
  @JsonKey(name: "sibling_gender")
  final String? siblingGender;
  @JsonKey(name: "relationship")
  final int? relationship;

  Siblings({
    this.idSibling,
    this.childId,
    this.siblingName,
    this.siblingAge,
    this.siblingGender,
    this.relationship,
  });

  factory Siblings.fromJson(Map<String, dynamic> json) {
    return _$SiblingsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SiblingsToJson(this);
  }
}

@JsonSerializable()
class BestPlaymate {
  @JsonKey(name: "id_playmate")
  final int? idPlaymate;
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "playmate_name")
  final String? playmateName;
  @JsonKey(name: "playmate_age")
  final int? playmateAge;
  @JsonKey(name: "playmate_gender")
  final String? playmateGender;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  BestPlaymate({
    this.idPlaymate,
    this.idChildren,
    this.playmateName,
    this.playmateAge,
    this.playmateGender,
    this.createdAt,
    this.updatedAt,
  });

  factory BestPlaymate.fromJson(Map<String, dynamic> json) {
    return _$BestPlaymateFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BestPlaymateToJson(this);
  }
}
