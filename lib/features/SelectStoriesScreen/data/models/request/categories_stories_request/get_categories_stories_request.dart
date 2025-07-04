import 'package:json_annotation/json_annotation.dart';

part 'get_categories_stories_request.g.dart';

@JsonSerializable()
class GetCategoriesStoriesRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  GetCategoriesStoriesRequest ({
    this.userId,
  });

  factory GetCategoriesStoriesRequest.fromJson(Map<String, dynamic> json) {
    return _$GetCategoriesStoriesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetCategoriesStoriesRequestToJson(this);
  }
}


