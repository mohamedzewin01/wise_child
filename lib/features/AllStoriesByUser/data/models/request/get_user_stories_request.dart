import 'package:json_annotation/json_annotation.dart';

part 'get_user_stories_request.g.dart';

@JsonSerializable()
class GetUserStoriesRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  GetUserStoriesRequest ({
    this.userId,
  });

  factory GetUserStoriesRequest.fromJson(Map<String, dynamic> json) {
    return _$GetUserStoriesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetUserStoriesRequestToJson(this);
  }
}


