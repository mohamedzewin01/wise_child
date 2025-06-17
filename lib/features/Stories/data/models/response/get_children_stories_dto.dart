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
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "child_name")
  final String? childName;
  @JsonKey(name: "image_cover")
  final String? imageCover;
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "question_id")
  final int? questionId;
  @JsonKey(name: "option_text")
  final String? optionText;

  StoriesList ({
    this.storyId,
    this.childId,
    this.userId,
    this.childName,
    this.imageCover,
    this.problemId,
    this.createdAt,
    this.id,
    this.questionId,
    this.optionText,
  });

  factory StoriesList.fromJson(Map<String, dynamic> json) {
    return _$StoriesListFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesListToJson(this);
  }

}


