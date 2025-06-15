import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';

part 'delete_children_dto.g.dart';

@JsonSerializable()
class DeleteChildrenDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteChildrenDto ({
    this.status,
    this.message,
  });

  factory DeleteChildrenDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteChildrenDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteChildrenDtoToJson(this);
  }
  DeleteChildrenEntity toEntity() {
    return DeleteChildrenEntity(
      status: status,
      message: message,
    );
  }
}


