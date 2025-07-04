import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/_add_kids_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/save_story_entity.dart';
part 'save_story_dto.g.dart';

@JsonSerializable()
class SaveStoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  SaveStoryDto ({
    this.status,
    this.message,
  });

  factory SaveStoryDto.fromJson(Map<String, dynamic> json) {
    return _$SaveStoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SaveStoryDtoToJson(this);
  }
  SaveStoryEntity toEntity() => SaveStoryEntity(status: status, message: message);
}


