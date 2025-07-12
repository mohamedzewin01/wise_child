// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportsDto _$ReportsDtoFromJson(Map<String, dynamic> json) => ReportsDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ReportData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReportsDtoToJson(ReportsDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
  childId: (json['child_id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  stories: (json['stories'] as List<dynamic>?)
      ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'child_id': instance.childId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'stories': instance.stories,
    };

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  storyCreatedAt: json['story_created_at'] as String?,
  totalViews: (json['total_views'] as num?)?.toInt(),
  lastViewed: json['last_viewed'] as String?,
);

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'story_created_at': instance.storyCreatedAt,
  'total_views': instance.totalViews,
  'last_viewed': instance.lastViewed,
};
