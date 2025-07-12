// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_child_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildReviewRequest _$GetChildReviewRequestFromJson(
  Map<String, dynamic> json,
) => GetChildReviewRequest(
  userId: json['user_id'] as String?,
  idChildren: (json['id_children'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetChildReviewRequestToJson(
  GetChildReviewRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'id_children': instance.idChildren,
};
