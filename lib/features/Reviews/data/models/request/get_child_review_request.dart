import 'package:json_annotation/json_annotation.dart';

part 'get_child_review_request.g.dart';

@JsonSerializable()
class GetChildReviewRequest {
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "id_children")
  final int? idChildren;

  GetChildReviewRequest ({
    this.userId,
    this.idChildren,
  });

  factory GetChildReviewRequest.fromJson(Map<String, dynamic> json) {
    return _$GetChildReviewRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildReviewRequestToJson(this);
  }
}


