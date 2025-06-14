import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/NewChildren/domain/entities/upload_image_entity.dart';

part 'upload_image.dto.g.dart';

@JsonSerializable()
class UploadImageDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;

  UploadImageDto ( {
    this.status,
    this.message,
    this.imageUrl,
  });


  factory UploadImageDto.fromJson(Map<String, dynamic> json) {
    return _$UploadImageDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UploadImageDtoToJson(this);
  }
  UploadImageEntity toEntity() {
    return UploadImageEntity(
      status: status,
      message: message,
    );
  }
}


