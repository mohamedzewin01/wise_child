import 'package:json_annotation/json_annotation.dart';

part 'get_children_stories_request.g.dart';

@JsonSerializable()
class GetChildrenStoriesRequest {
  @JsonKey(name: "children_id")
  final int? childrenId;

  GetChildrenStoriesRequest ({
    this.childrenId,
  });

  factory GetChildrenStoriesRequest.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenStoriesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenStoriesRequestToJson(this);
  }
}


