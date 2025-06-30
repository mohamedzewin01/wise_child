import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/stories_by_category_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';

abstract class SelectStoriesScreenDatasourceRepo {
  Future<Result<GetCategoriesStoriesEntity?>> getCategoriesStories();

  Future<Result<StoriesByCategoryEntity?>> storiesByCategory({
    int? categoryId,
    int? idChildren,
    int? page,
  });


  Future<Result<SaveStoryEntity?>> saveChildrenStories(SaveStoryRequest saveStoryRequest);

}
