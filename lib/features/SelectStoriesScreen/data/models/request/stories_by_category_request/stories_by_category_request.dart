import 'package:json_annotation/json_annotation.dart';

part 'stories_by_category_request.g.dart';

@JsonSerializable()
class StoriesByCategoryRequest {
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "limit")
  final int? limit;

  StoriesByCategoryRequest ({
    this.userId,
    this.categoryId,
    this.idChildren,
    this.page,
    this.limit,
  });

  factory StoriesByCategoryRequest.fromJson(Map<String, dynamic> json) {
    return _$StoriesByCategoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesByCategoryRequestToJson(this);
  }
}


