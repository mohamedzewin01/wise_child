import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/request/get_user_stories_request.dart';

import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';

import 'AllStoriesByUser_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: AllStoriesByUserDatasourceRepo)
class AllStoriesByUserDatasourceRepoImpl
    implements AllStoriesByUserDatasourceRepo {
  final ApiService apiService;

  AllStoriesByUserDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<UserStoriesEntity?>> getUserStories() {
    return executeApi(() async {
      String userId1 = CacheService.getData(key: CacheKeys.userId);
      GetUserStoriesRequest getUserStoriesRequest = GetUserStoriesRequest(
        userId: userId1,
      );
      var response = await apiService.getUserStories(getUserStoriesRequest);
      return response?.toEntity();
    });
  }
}
