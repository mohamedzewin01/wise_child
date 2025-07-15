import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/datasources/StoriesUnderCategory_datasource_repo.dart';
import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';
import '../../domain/repositories/StoriesUnderCategory_repository.dart';

@Injectable(as: StoriesUnderCategoryRepository)
class StoriesUnderCategoryRepositoryImpl implements StoriesUnderCategoryRepository {
  final StoriesUnderCategoryDatasourceRepo storiesUnderCategoryDatasourceRepo;
  StoriesUnderCategoryRepositoryImpl(this.storiesUnderCategoryDatasourceRepo);

  @override
  Future<Result<StoriesUnderCategoryEntity?>> getStoriesUnderCategory(int categoryId) {
   return storiesUnderCategoryDatasourceRepo.getStoriesUnderCategory(categoryId);
  }
  // implementation
}
