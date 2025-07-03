import 'package:json_annotation/json_annotation.dart';

part 'story_details_request.g.dart';

@JsonSerializable()
class StoryDetailsRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  @JsonKey(name: "story_id")
  final int? storyId;

  @JsonKey(name: "id_children")
  final int? idChildren;

  StoryDetailsRequest({
    this.userId,
    this.storyId,
    this.idChildren,
  });

  factory StoryDetailsRequest.fromJson(Map<String, dynamic> json) {
    return _$StoryDetailsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryDetailsRequestToJson(this);
  }
}
