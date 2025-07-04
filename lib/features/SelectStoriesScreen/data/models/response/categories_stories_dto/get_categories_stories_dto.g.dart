// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_categories_stories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCategoriesStoriesDto _$GetCategoriesStoriesDtoFromJson(
  Map<String, dynamic> json,
) => GetCategoriesStoriesDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  hasCategories: json['has_categories'] as bool?,
  count: (json['count'] as num?)?.toInt(),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetCategoriesStoriesDtoToJson(
  GetCategoriesStoriesDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'has_categories': instance.hasCategories,
  'count': instance.count,
  'categories': instance.categories,
};

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
  categoryDescription: json['category_description'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_description': instance.categoryDescription,
      'created_at': instance.createdAt,
    };
