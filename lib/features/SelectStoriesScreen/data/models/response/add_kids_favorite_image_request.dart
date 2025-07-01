import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';

part 'add_kids_favorite_image_request.g.dart';

@JsonSerializable()
class AddKidsFavoriteImageRequest {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;

  AddKidsFavoriteImageRequest ({
    this.status,
    this.message,
    this.imageUrl,
  });

  factory AddKidsFavoriteImageRequest.fromJson(Map<String, dynamic> json) {
    return _$AddKidsFavoriteImageRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddKidsFavoriteImageRequestToJson(this);
  }
  AddKidsFavoriteImageEntity toEntity() => AddKidsFavoriteImageEntity(
    status: status,
    message: message,
    imageUrl: imageUrl,
  );
}


