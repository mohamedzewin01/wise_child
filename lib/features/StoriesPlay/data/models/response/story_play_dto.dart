import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';

part 'story_play_dto.g.dart';

@JsonSerializable()
class StoryPlayDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "clips")
  final List<Clips>? clips;

  StoryPlayDto({this.status, this.clips});

  factory StoryPlayDto.fromJson(Map<String, dynamic> json) {
    return _$StoryPlayDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryPlayDtoToJson(this);
  }

  StoryPlayEntity toEntity() => StoryPlayEntity(
    status: status,
    clips: clips,
  );
}

@JsonSerializable()
class Clips {
  @JsonKey(name: "clip_group_id")
  final int? clipGroupId;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "audio_url")
  final String? audioUrl;
  @JsonKey(name: "clip_text")
  final String? clipText;
  @JsonKey(name: "insert_child_name")
  final String? insertChildName;
  @JsonKey(name: "clip_created_at")
  final String? clipCreatedAt;

  Clips({
    this.clipGroupId,
    this.imageUrl,
    this.audioUrl,
    this.clipText,
    this.insertChildName,
    this.clipCreatedAt,

  });

  factory Clips.fromJson(Map<String, dynamic> json) {
    return _$ClipsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ClipsToJson(this);
  }

  // ClipEntity toEntity() => ClipEntity(imageUrl: imageUrl, clipText: clipText);
}
