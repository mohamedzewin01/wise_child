import 'package:json_annotation/json_annotation.dart';

part 'story_play_request.g.dart';

@JsonSerializable()
class StoryPlayRequestModel {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "child_name")
  final String? childName;

  StoryPlayRequestModel ({
    this.storyId,
    this.childName
  });

  factory StoryPlayRequestModel.fromJson(Map<String, dynamic> json) {
    return _$StoryPlayRequestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryPlayRequestModelToJson(this);
  }
}


