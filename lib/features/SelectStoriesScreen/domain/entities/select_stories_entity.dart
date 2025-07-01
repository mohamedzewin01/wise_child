import 'package:wise_child/features/SelectStoriesScreen/data/models/response/get_categories_stories_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto.dart';

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

class StoriesByCategoryEntity {
  final String? status;

  final String? message;

  final int? page;

  final int? limit;

  final int? total;

  final int? pages;

  final int? count;

  final List<StoriesCategory>? stories;

  StoriesByCategoryEntity({
    this.status,
    this.message,
    this.page,
    this.limit,
    this.total,
    this.pages,
    this.count,
    this.stories,
  });
}

class SaveStoryEntity {
  final String? status;

  final String? message;

  SaveStoryEntity({this.status, this.message});
}

class AddKidsFavoriteImageEntity {
  final String? status;

  final String? message;

  final String? imageUrl;

  AddKidsFavoriteImageEntity({this.status, this.message, this.imageUrl});
}
