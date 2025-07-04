import 'dart:io';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/_add_kids_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/delete_kid_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/save_story_entity.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/stories_by_category_entity.dart';

abstract class SelectStoriesScreenUseCaseRepo {
  Future<Result<GetCategoriesStoriesEntity?>> getCategoriesStories();

  Future<Result<StoriesByCategoryEntity?>> storiesByCategory({
    int? categoryId,
    int? idChildren,
    int? page,
  });

  Future<Result<SaveStoryEntity?>> saveChildrenStories(
    SaveStoryRequest saveStoryRequest,
  );
  Future<Result<AddKidsFavoriteImageEntity?>> addKidsFavoriteImage({
    File? image,
    int? idChildren,
    int? storyId,
  });
  Future<Result<DeleteKidFavImageEntity?>> deleteKidsFavImage({
   required int? storyId,
   required int? idChildren,
  });
}
