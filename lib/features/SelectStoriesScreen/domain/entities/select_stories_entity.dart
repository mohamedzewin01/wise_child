import 'package:wise_child/features/SelectStoriesScreen/data/models/response/categories_stories_dto/get_categories_stories_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto/stories_by_category_dto.dart';

class GetCategoriesStoriesEntity {
  final String? status;

  final String? message;

  final bool? hasCategories;

  final int? count;

  final List<Categories>? categories;

  GetCategoriesStoriesEntity({
    this.status,
    this.message,
    this.hasCategories,
    this.count,
    this.categories,
  });
}





