import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto/stories_by_category_dto.dart';

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