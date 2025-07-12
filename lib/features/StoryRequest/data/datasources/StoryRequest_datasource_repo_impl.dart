import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/add_story_requests_model.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/get_children_request.dart';

import 'package:wise_child/features/StoryRequest/domain/entities/story_request_entities.dart';

import '../../../../core/common/api_result.dart';
import 'StoryRequest_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoryRequestDatasourceRepo)
class StoryRequestDatasourceRepoImpl implements StoryRequestDatasourceRepo {
  final ApiService apiService;

  StoryRequestDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetUserChildrenEntity?>> getChildrenUser() {
    return executeApi(() async {
      final String? userId = CacheService.getData(key: CacheKeys.userId);
      GetChildrenUserRequest getChildrenUserRequest = GetChildrenUserRequest(
        userId: userId,
      );
      final response = await apiService.getChildrenUser(getChildrenUserRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<AddStoryRequestsEntity?>> addStoryRequest(AddStoryRequestsModel addStoryRequestsModel) {
  return executeApi(() async {

    final response = await apiService.addStoryRequests(addStoryRequestsModel);
    return response?.toEntity();

  });
  }
}
