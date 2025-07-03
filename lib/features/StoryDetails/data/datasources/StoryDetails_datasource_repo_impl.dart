import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/StoryDetails/data/models/request/story_details_request.dart';

import 'package:wise_child/features/StoryDetails/domain/entities/story_details_entities.dart';

import 'StoryDetails_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoryDetailsDatasourceRepo)
class StoryDetailsDatasourceRepoImpl implements StoryDetailsDatasourceRepo {
  final ApiService apiService;
  StoryDetailsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<StoryDetailsEntity?>> storyDetails(int storyId,int childId) {
    return executeApi(()async {
      String? userId =CacheService.getData(key: CacheKeys.userId);
      StoryDetailsRequest storyDetailsRequest = StoryDetailsRequest(storyId: storyId,userId:userId ,idChildren: childId);
      final response = await apiService.storyChildrenDetails(storyDetailsRequest);
      return response?.toEntity();
    },);
  }
}
