// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_by_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesByCategoryRequest _$StoriesByCategoryRequestFromJson(
  Map<String, dynamic> json,
) => StoriesByCategoryRequest(
  userId: json['user_id'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  idChildren: (json['id_children'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
);

Map<String, dynamic> _$StoriesByCategoryRequestToJson(
  StoriesByCategoryRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'category_id': instance.categoryId,
  'id_children': instance.idChildren,
  'page': instance.page,
  'limit': instance.limit,
};
