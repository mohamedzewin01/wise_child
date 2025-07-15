import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/request/stories_under_category_request.dart';

import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';

import 'StoriesUnderCategory_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoriesUnderCategoryDatasourceRepo)
class StoriesUnderCategoryDatasourceRepoImpl implements StoriesUnderCategoryDatasourceRepo {
  final ApiService apiService;
  StoriesUnderCategoryDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<StoriesUnderCategoryEntity?>> getStoriesUnderCategory(int categoryId) {
   return executeApi(()async {
     StoriesUnderCategoryRequest storiesUnderCategoryRequest = StoriesUnderCategoryRequest(categoryId: categoryId);
     var response = await apiService.storiesUnderCategory(storiesUnderCategoryRequest);
     return response?.toEntity();

   },);
  }
}
