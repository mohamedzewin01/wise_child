// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_play_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryPlayDto _$StoryPlayDtoFromJson(Map<String, dynamic> json) => StoryPlayDto(
  status: json['status'] as String?,
  clips: (json['clips'] as List<dynamic>?)
      ?.map((e) => Clips.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StoryPlayDtoToJson(StoryPlayDto instance) =>
    <String, dynamic>{'status': instance.status, 'clips': instance.clips};

Clips _$ClipsFromJson(Map<String, dynamic> json) => Clips(
  clipGroupId: (json['clip_group_id'] as num?)?.toInt(),
  imageUrl: json['image_url'] as String?,
  audioUrl: json['audio_url'] as String?,
  clipText: json['clip_text'] as String?,
  insertChildName: json['insert_child_name'] as String?,
  clipCreatedAt: json['clip_created_at'] as String?,
);

Map<String, dynamic> _$ClipsToJson(Clips instance) => <String, dynamic>{
  'clip_group_id': instance.clipGroupId,
  'image_url': instance.imageUrl,
  'audio_url': instance.audioUrl,
  'clip_text': instance.clipText,
  'insert_child_name': instance.insertChildName,
  'clip_created_at': instance.clipCreatedAt,
};
