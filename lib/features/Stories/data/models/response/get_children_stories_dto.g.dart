// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_children_stories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildrenStoriesDto _$GetChildrenStoriesDtoFromJson(
  Map<String, dynamic> json,
) => GetChildrenStoriesDto(
  status: json['status'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetChildrenStoriesDtoToJson(
  GetChildrenStoriesDto instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  storiesList: (json['storiesList'] as List<dynamic>?)
      ?.map((e) => StoriesList.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'storiesList': instance.storiesList,
};

StoriesList _$StoriesListFromJson(Map<String, dynamic> json) => StoriesList(
  storyId: (json['story_id'] as num?)?.toInt(),
  childId: (json['child_id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  childName: json['child_name'] as String?,
  imageCover: json['image_cover'] as String?,
  problemId: (json['problem_id'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  id: (json['id'] as num?)?.toInt(),
  questionId: (json['question_id'] as num?)?.toInt(),
  optionText: json['option_text'] as String?,
);

Map<String, dynamic> _$StoriesListToJson(StoriesList instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'child_id': instance.childId,
      'user_id': instance.userId,
      'child_name': instance.childName,
      'image_cover': instance.imageCover,
      'problem_id': instance.problemId,
      'created_at': instance.createdAt,
      'id': instance.id,
      'question_id': instance.questionId,
      'option_text': instance.optionText,
    };
