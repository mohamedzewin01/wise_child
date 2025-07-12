import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';

part 'get_children_review_dto.g.dart';

@JsonSerializable()
class GetChildrenReviewDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "review")
  final ChildrenReviewData? review;

  GetChildrenReviewDto ({
    this.status,
    this.message,
    this.review,
  });

  factory GetChildrenReviewDto.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenReviewDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenReviewDtoToJson(this);
  }
  GetChildrenReviewEntity toEntity() {
    return GetChildrenReviewEntity(
      status: status,
      message: message,
      review: review,
    );
  }
}

@JsonSerializable()
class ChildrenReviewData {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "review_text")
  final String? reviewText;
  @JsonKey(name: "rating")
  final int? rating;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  ChildrenReviewData ({
    this.id,
    this.reviewText,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory ChildrenReviewData.fromJson(Map<String, dynamic> json) {
    return _$ChildrenReviewDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildrenReviewDataToJson(this);
  }

}


