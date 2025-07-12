// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_children_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildrenReviewDto _$GetChildrenReviewDtoFromJson(
  Map<String, dynamic> json,
) => GetChildrenReviewDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  review: json['review'] == null
      ? null
      : ChildrenReviewData.fromJson(json['review'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetChildrenReviewDtoToJson(
  GetChildrenReviewDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'review': instance.review,
};

ChildrenReviewData _$ChildrenReviewDataFromJson(Map<String, dynamic> json) =>
    ChildrenReviewData(
      id: (json['id'] as num?)?.toInt(),
      reviewText: json['review_text'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ChildrenReviewDataToJson(ChildrenReviewData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'review_text': instance.reviewText,
      'rating': instance.rating,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
