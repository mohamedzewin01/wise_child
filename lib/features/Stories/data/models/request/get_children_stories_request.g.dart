// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_children_stories_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildrenStoriesRequest _$GetChildrenStoriesRequestFromJson(
  Map<String, dynamic> json,
) => GetChildrenStoriesRequest(
  childrenId: (json['children_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetChildrenStoriesRequestToJson(
  GetChildrenStoriesRequest instance,
) => <String, dynamic>{'children_id': instance.childrenId};
