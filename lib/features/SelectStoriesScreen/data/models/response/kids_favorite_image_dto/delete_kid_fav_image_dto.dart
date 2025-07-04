import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/delete_kid_fav_image_entity.dart';

part 'delete_kid_fav_image_dto.g.dart';

@JsonSerializable()
class DeleteKidFavImageDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteKidFavImageDto({this.status, this.message});

  factory DeleteKidFavImageDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteKidFavImageDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteKidFavImageDtoToJson(this);
  }

  DeleteKidFavImageEntity toEntity() {
    return DeleteKidFavImageEntity(status: status, message: message);
  }
}
