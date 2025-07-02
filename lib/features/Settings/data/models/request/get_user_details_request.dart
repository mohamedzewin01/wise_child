import 'package:json_annotation/json_annotation.dart';

part 'get_user_details_request.g.dart';

@JsonSerializable()
class GetUserDetailsRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  GetUserDetailsRequest ({
    this.userId,
  });

  factory GetUserDetailsRequest.fromJson(Map<String, dynamic> json) {
    return _$GetUserDetailsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetUserDetailsRequestToJson(this);
  }
}


