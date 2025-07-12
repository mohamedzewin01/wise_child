// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_story_requests_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddStoryRequestsModel _$AddStoryRequestsModelFromJson(
  Map<String, dynamic> json,
) => AddStoryRequestsModel(
  userId: json['user_id'] as String?,
  idChildren: (json['id_children'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemText: json['problem_text'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AddStoryRequestsModelToJson(
  AddStoryRequestsModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'id_children': instance.idChildren,
  'problem_title': instance.problemTitle,
  'problem_text': instance.problemText,
  'notes': instance.notes,
};
