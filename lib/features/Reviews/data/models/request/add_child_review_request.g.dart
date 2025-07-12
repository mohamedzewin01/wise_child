// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildReviewRequest _$AddChildReviewRequestFromJson(
  Map<String, dynamic> json,
) => AddChildReviewRequest(
  userId: json['user_id'] as String?,
  idChildren: (json['id_children'] as num?)?.toInt(),
  reviewText: json['review_text'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
);

Map<String, dynamic> _$AddChildReviewRequestToJson(
  AddChildReviewRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'id_children': instance.idChildren,
  'review_text': instance.reviewText,
  'rating': instance.rating,
};
