// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectionsDto _$DirectionsDtoFromJson(Map<String, dynamic> json) =>
    DirectionsDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      directions: (json['directions'] as List<dynamic>?)
          ?.map((e) => Directions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DirectionsDtoToJson(DirectionsDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'directions': instance.directions,
    };

Directions _$DirectionsFromJson(Map<String, dynamic> json) => Directions(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'],
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$DirectionsToJson(Directions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'created_at': instance.createdAt,
    };
