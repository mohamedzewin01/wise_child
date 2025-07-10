import 'package:json_annotation/json_annotation.dart';

part 'add_view_story_request.g.dart';

@JsonSerializable()
class AddViewStoryRequest {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "child_id")
  final int? childId;

  AddViewStoryRequest ({
    this.storyId,
    this.childId,
  });

  factory AddViewStoryRequest.fromJson(Map<String, dynamic> json) {
    return _$AddViewStoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddViewStoryRequestToJson(this);
  }
}


