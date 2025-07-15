import 'package:json_annotation/json_annotation.dart';

part 'story_info_request.g.dart';

@JsonSerializable()
class StoryInfoRequest {
  @JsonKey(name: "story_id")
  final int? storyId;

  StoryInfoRequest ({
    this.storyId,
  });

  factory StoryInfoRequest.fromJson(Map<String, dynamic> json) {
    return _$StoryInfoRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryInfoRequestToJson(this);
  }
}


