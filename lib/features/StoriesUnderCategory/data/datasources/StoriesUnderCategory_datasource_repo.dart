import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';

abstract class StoriesUnderCategoryDatasourceRepo {
  Future<Result<StoriesUnderCategoryEntity?>>getStoriesUnderCategory(int categoryId);

}
