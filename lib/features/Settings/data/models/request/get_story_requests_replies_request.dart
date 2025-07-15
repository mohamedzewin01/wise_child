import 'package:json_annotation/json_annotation.dart';

part 'get_story_requests_replies_request.g.dart';

@JsonSerializable()
class GetStoryRequestsRepliesRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  GetStoryRequestsRepliesRequest ({
    this.userId,
  });

  factory GetStoryRequestsRepliesRequest.fromJson(Map<String, dynamic> json) {
    return _$GetStoryRequestsRepliesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetStoryRequestsRepliesRequestToJson(this);
  }
}


