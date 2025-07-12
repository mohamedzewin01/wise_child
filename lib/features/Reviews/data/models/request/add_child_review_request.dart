import 'package:json_annotation/json_annotation.dart';

part 'add_child_review_request.g.dart';

@JsonSerializable()
class AddChildReviewRequest {
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "review_text")
  final String? reviewText;
  @JsonKey(name: "rating")
  final int? rating;

  AddChildReviewRequest ({
    this.userId,
    this.idChildren,
    this.reviewText,
    this.rating,
  });

  factory AddChildReviewRequest.fromJson(Map<String, dynamic> json) {
    return _$AddChildReviewRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddChildReviewRequestToJson(this);
  }
}


