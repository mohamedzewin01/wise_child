import 'package:json_annotation/json_annotation.dart';

part 'stories_under_category_request.g.dart';

@JsonSerializable()
class StoriesUnderCategoryRequest {
  @JsonKey(name: "category_id")
  final int? categoryId;

  StoriesUnderCategoryRequest ({
    this.categoryId,
  });

  factory StoriesUnderCategoryRequest.fromJson(Map<String, dynamic> json) {
    return _$StoriesUnderCategoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesUnderCategoryRequestToJson(this);
  }
}


