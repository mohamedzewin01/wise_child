import 'package:json_annotation/json_annotation.dart';

part 'get_children_request.g.dart';

@JsonSerializable()
class GetChildrenRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  GetChildrenRequest ({
    this.userId,
  });

  factory GetChildrenRequest.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenRequestToJson(this);
  }
}


