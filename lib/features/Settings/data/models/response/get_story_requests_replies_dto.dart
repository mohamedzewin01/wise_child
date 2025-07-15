// import 'package:json_annotation/json_annotation.dart';
// import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';
//
// part 'get_story_requests_replies_dto.g.dart';
//
// @JsonSerializable()
// class GetStoryRequestsRepliesDto {
//   @JsonKey(name: "status")
//   final String? status;
//   @JsonKey(name: "message")
//   final String? message;
//   @JsonKey(name: "data")
//   final List<DataStoryRequest>? data;
//
//   GetStoryRequestsRepliesDto ({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory GetStoryRequestsRepliesDto.fromJson(Map<String, dynamic> json) {
//     return _$GetStoryRequestsRepliesDtoFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$GetStoryRequestsRepliesDtoToJson(this);
//   }
//   GetStoryRequestsRepliesEntity toEntity() {
//     return GetStoryRequestsRepliesEntity(
//       status: status,
//       message: message,
//       data: data,
//     );
//   }
// }
//
// @JsonSerializable()
// class DataStoryRequest {
//   @JsonKey(name: "request_id")
//   final int? requestId;
//   @JsonKey(name: "child_id")
//   final int? childId;
//   @JsonKey(name: "problem_title")
//   final String? problemTitle;
//   @JsonKey(name: "problem_text")
//   final String? problemText;
//   @JsonKey(name: "notes")
//   final String? notes;
//   @JsonKey(name: "status")
//   final String? status;
//   @JsonKey(name: "created_at")
//   final String? createdAt;
//   @JsonKey(name: "updated_at")
//   final String? updatedAt;
//   @JsonKey(name: "reply")
//   final Reply? reply;
//
//   DataStoryRequest ({
//     this.requestId,
//     this.childId,
//     this.problemTitle,
//     this.problemText,
//     this.notes,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.reply,
//   });
//
//   factory DataStoryRequest.fromJson(Map<String, dynamic> json) {
//     return _$DataStoryRequestFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$DataStoryRequestToJson(this);
//   }
// }
//
// @JsonSerializable()
// class Reply {
//   @JsonKey(name: "reply_id")
//   final int? replyId;
//   @JsonKey(name: "reply_text")
//   final String? replyText;
//   @JsonKey(name: "attached_story")
//   final AttachedStory? attachedStory;
//   @JsonKey(name: "created_at")
//   final String? createdAt;
//   @JsonKey(name: "updated_at")
//   final String? updatedAt;
//
//   Reply ({
//     this.replyId,
//     this.replyText,
//     this.attachedStory,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Reply.fromJson(Map<String, dynamic> json) {
//     return _$ReplyFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$ReplyToJson(this);
//   }
// }
//
// @JsonSerializable()
// class AttachedStory {
//   @JsonKey(name: "story_id")
//   final int? storyId;
//   @JsonKey(name: "story_title")
//   final String? storyTitle;
//   @JsonKey(name: "image_cover")
//   final String? imageCover;
//   @JsonKey(name: "story_description")
//   final String? storyDescription;
//
//   AttachedStory ({
//     this.storyId,
//     this.storyTitle,
//     this.imageCover,
//     this.storyDescription,
//   });
//
//   factory AttachedStory.fromJson(Map<String, dynamic> json) {
//     return _$AttachedStoryFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$AttachedStoryToJson(this);
//   }
// }
//

import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';

part 'get_story_requests_replies_dto.g.dart';

@JsonSerializable()
class GetStoryRequestsRepliesDto {
  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "data")
  final List<DataStoryRequest>? data;

  GetStoryRequestsRepliesDto({
    this.status,
    this.message,
    this.data,
  });

  factory GetStoryRequestsRepliesDto.fromJson(Map<String, dynamic> json) =>
      _$GetStoryRequestsRepliesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetStoryRequestsRepliesDtoToJson(this);

  GetStoryRequestsRepliesEntity toEntity() {
    return GetStoryRequestsRepliesEntity(
      status: status,
      message: message,
      data: data,
    );
  }
}

@JsonSerializable()
class DataStoryRequest {
  @JsonKey(name: "request_id")
  final int? requestId;

  @JsonKey(name: "child_id")
  final int? childId;

  @JsonKey(name: "problem_title")
  final String? problemTitle;

  @JsonKey(name: "problem_text")
  final String? problemText;

  @JsonKey(name: "notes")
  final String? notes;

  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  @JsonKey(name: "reply")
  final Reply? reply;

  // **جديد: إضافة بيانات الطفل**
  @JsonKey(name: "child")
  final Child? child;

  DataStoryRequest({
    this.requestId,
    this.childId,
    this.problemTitle,
    this.problemText,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.reply,
    this.child,
  });

  factory DataStoryRequest.fromJson(Map<String, dynamic> json) =>
      _$DataStoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DataStoryRequestToJson(this);
}

@JsonSerializable()
class Reply {
  @JsonKey(name: "reply_id")
  final int? replyId;

  @JsonKey(name: "reply_text")
  final String? replyText;

  @JsonKey(name: "attached_story")
  final AttachedStory? attachedStory;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Reply({
    this.replyId,
    this.replyText,
    this.attachedStory,
    this.createdAt,
    this.updatedAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}

@JsonSerializable()
class AttachedStory {
  @JsonKey(name: "story_id")
  final int? storyId;

  @JsonKey(name: "story_title")
  final String? storyTitle;

  @JsonKey(name: "image_cover")
  final String? imageCover;

  @JsonKey(name: "story_description")
  final String? storyDescription;

  AttachedStory({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
  });

  factory AttachedStory.fromJson(Map<String, dynamic> json) =>
      _$AttachedStoryFromJson(json);

  Map<String, dynamic> toJson() => _$AttachedStoryToJson(this);
}

@JsonSerializable()
class Child {
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

  @JsonKey(name: "siblings_count")
  final int? siblingsCount;

  @JsonKey(name: "friends_count")
  final int? friendsCount;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Child({
    this.idChildren,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
    this.emailChildren,
    this.siblingsCount,
    this.friendsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  Map<String, dynamic> toJson() => _$ChildToJson(this);
}
