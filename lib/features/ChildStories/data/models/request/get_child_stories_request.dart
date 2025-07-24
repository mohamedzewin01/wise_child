import 'package:json_annotation/json_annotation.dart';

part 'get_child_stories_request.g.dart';

@JsonSerializable()
class GetChildStoriesRequest {
  @JsonKey(name: "child_id")
  final int? childId;

  GetChildStoriesRequest ({
    this.childId,
  });

  factory GetChildStoriesRequest.fromJson(Map<String, dynamic> json) {
    return _$GetChildStoriesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildStoriesRequestToJson(this);
  }
}


