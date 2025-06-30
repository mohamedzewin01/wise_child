import 'package:json_annotation/json_annotation.dart';

part 'save_story_request.g.dart';

@JsonSerializable()
class SaveStoryRequest {
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "children_id")
  final int? childrenId;
  @JsonKey(name: "stories_id")
  final int? storiesId;
  @JsonKey(name: "problem_id")
  final int? problemId;

  SaveStoryRequest ({
    this.userId,
    this.childrenId,
    this.storiesId,
    this.problemId,
  });

  factory SaveStoryRequest.fromJson(Map<String, dynamic> json) {
    return _$SaveStoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SaveStoryRequestToJson(this);
  }
}


