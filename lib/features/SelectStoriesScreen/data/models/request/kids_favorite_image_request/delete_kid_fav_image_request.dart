import 'package:json_annotation/json_annotation.dart';

part 'delete_kid_fav_image_request.g.dart';

@JsonSerializable()
class DeleteKidFavImageRequest {
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "story_id")
  final int? storyId;

  DeleteKidFavImageRequest ({
    this.idChildren,
    this.storyId,
  });

  factory DeleteKidFavImageRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteKidFavImageRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteKidFavImageRequestToJson(this);
  }
}


