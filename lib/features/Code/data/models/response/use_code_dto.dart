import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Code/domain/entities/code_entities.dart';

part 'use_code_dto.g.dart';

@JsonSerializable()
class UseCodeDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  UseCodeDto ({
    this.status,
    this.message,
  });

  factory UseCodeDto.fromJson(Map<String, dynamic> json) {
    return _$UseCodeDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UseCodeDtoToJson(this);
  }
  UseCodeEntity toEntity() {
    return UseCodeEntity(
      status: status,
      message: message,
    );
  }
}


