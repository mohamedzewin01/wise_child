import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Code/domain/entities/code_entities.dart';

part 'check_code_dto.g.dart';

@JsonSerializable()
class CheckCodeDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  CheckCodeDto ({
    this.status,
    this.message,
  });

  factory CheckCodeDto.fromJson(Map<String, dynamic> json) {
    return _$CheckCodeDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CheckCodeDtoToJson(this);
  }
  CheckCodeEntity toEntity() {
    return CheckCodeEntity(
      status: status,
      message: message,
    );
  }
}


