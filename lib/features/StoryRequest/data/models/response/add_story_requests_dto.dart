import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/StoryRequest/domain/entities/story_request_entities.dart';

part 'add_story_requests_dto.g.dart';

@JsonSerializable()
class AddStoryRequestsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddStoryRequestsDto ({
    this.status,
    this.message,
  });

  factory AddStoryRequestsDto.fromJson(Map<String, dynamic> json) {
    return _$AddStoryRequestsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddStoryRequestsDtoToJson(this);
  }
  AddStoryRequestsEntity toEntity() {
    return AddStoryRequestsEntity(
      status: status,
      message: message,
    );
  }
}


