import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';

part 'get_categories_stories_dto.g.dart';

@JsonSerializable()
class GetCategoriesStoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "has_categories")
  final bool? hasCategories;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "categories")
  final List<Categories>? categories;

  GetCategoriesStoriesDto ({
    this.status,
    this.message,
    this.hasCategories,
    this.count,
    this.categories,
  });

  factory GetCategoriesStoriesDto.fromJson(Map<String, dynamic> json) {
    return _$GetCategoriesStoriesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetCategoriesStoriesDtoToJson(this);
  }
  GetCategoriesStoriesEntity toEntity() => GetCategoriesStoriesEntity(
    status: status,
    message: message,
    hasCategories: hasCategories,
    count: count,
    categories: categories,
  );
}

@JsonSerializable()
class Categories {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Categories ({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.createdAt,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return _$CategoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoriesToJson(this);
  }
}


