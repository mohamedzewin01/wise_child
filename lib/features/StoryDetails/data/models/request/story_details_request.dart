import 'package:json_annotation/json_annotation.dart';

part 'story_details_request.g.dart';

@JsonSerializable()
class StoryDetailsRequest {
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "story_id")
  final int? storyId;

  StoryDetailsRequest ({
    this.userId,
    this.storyId,
  });

  factory StoryDetailsRequest.fromJson(Map<String, dynamic> json) {
    return _$StoryDetailsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryDetailsRequestToJson(this);
  }
}


