import 'dart:io';

import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/categories_stories_request/get_categories_stories_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/kids_favorite_image_request/delete_kid_fav_image_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/stories_by_category_request/stories_by_category_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/delete_kid_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/stories_by_category_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'SelectStoriesScreen_datasource_repo.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/_add_kids_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/save_story_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: SelectStoriesScreenDatasourceRepo)
class SelectStoriesScreenDatasourceRepoImpl
    implements SelectStoriesScreenDatasourceRepo {
  final ApiService apiService;

  SelectStoriesScreenDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetCategoriesStoriesEntity?>> getCategoriesStories() {
    return executeApi(() async {
      String? userId = CacheService.getData(key: CacheKeys.userId);
      GetCategoriesStoriesRequest getCategoriesStoriesRequest =
          GetCategoriesStoriesRequest(userId: userId);
      var stories = await apiService.getCategoriesStories(
        getCategoriesStoriesRequest,
      );
      return stories?.toEntity();
    });
  }

  @override
  Future<Result<StoriesByCategoryEntity?>> storiesByCategory({
    int? categoryId,
    int? idChildren,
    int? page,
  }) {
    return executeApi(() async {
      StoriesByCategoryRequest storiesByCategoryRequest =
          StoriesByCategoryRequest(
            userId: CacheService.getData(key: CacheKeys.userId),
            limit: 10,
            categoryId: categoryId,
            page: page,
            idChildren: idChildren,
          );
      var stories = await apiService.storiesByCategory(
        storiesByCategoryRequest,
      );
      return stories?.toEntity();
    });
  }

  @override
  Future<Result<SaveStoryEntity?>> saveChildrenStories(
    SaveStoryRequest saveStoryRequest,
  ) {
    return executeApi(() async {
      var stories = await apiService.saveChildStory(saveStoryRequest);
      return stories?.toEntity();
    });
  }

  @override
  Future<Result<AddKidsFavoriteImageEntity?>> addKidsFavoriteImage({
    File? image,
    int? idChildren,
    int? storyId,
  }) {
    return executeApi(() async {
      var stories = await apiService.addKidsFavoriteImage(
        image,
        idChildren,
        storyId,
      );
      return stories?.toEntity();
    });
  }

  @override
  Future<Result<DeleteKidFavImageEntity?>> deleteKidsFavImage(
    int? storyId,
    int? idChildren,
  ) {
    return executeApi(() async {
      DeleteKidFavImageRequest deleteKidFavImage = DeleteKidFavImageRequest(
        idChildren: idChildren,
        storyId: storyId,
      );
      var stories = await apiService.deleteKidsFavoriteImage(deleteKidFavImage);
      return stories?.toEntity();
    });
  }
}
