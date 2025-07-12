import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';

part 'add_child_review_dto.g.dart';

@JsonSerializable()
class AddChildReviewDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddChildReviewDto ({
    this.status,
    this.message,
  });

  factory AddChildReviewDto.fromJson(Map<String, dynamic> json) {
    return _$AddChildReviewDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddChildReviewDtoToJson(this);
  }
  AddChildReviewEntity toEntity() {
    return AddChildReviewEntity(
      status: status,
      message: message,
    );
  }
}


