import 'package:json_annotation/json_annotation.dart';

part 'get_children_request.g.dart';

@JsonSerializable()
class GetChildrenUserRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  GetChildrenUserRequest ({
    this.userId,
  });

  factory GetChildrenUserRequest.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenUserRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenUserRequestToJson(this);
  }
}


