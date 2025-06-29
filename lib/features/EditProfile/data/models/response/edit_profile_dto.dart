import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';

part 'edit_profile_dto.g.dart';

@JsonSerializable()
class EditProfileDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  EditProfileDto ({
    this.status,
    this.message,
    this.updatedAt,
  });

  factory EditProfileDto.fromJson(Map<String, dynamic> json) {
    return _$EditProfileDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$EditProfileDtoToJson(this);
  }
  EditProfileEntity toEntity() {
    return EditProfileEntity(
      status: status,
      message: message,
      updatedAt: updatedAt,
    );
  }
}


