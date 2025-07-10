import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Analysis/domain/entities/analysis_entities.dart';

part 'add_view_story_dto.g.dart';

@JsonSerializable()
class AddViewStoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddViewStoryDto ({
    this.status,
    this.message,
  });

  factory AddViewStoryDto.fromJson(Map<String, dynamic> json) {
    return _$AddViewStoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddViewStoryDtoToJson(this);
  }
  AddViewStoryEntity toEntity() {
    return AddViewStoryEntity(
      status: status,
      message: message,
    );
  }
}


