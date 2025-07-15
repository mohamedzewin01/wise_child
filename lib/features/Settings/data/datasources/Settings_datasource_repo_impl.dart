import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Settings/data/models/request/get_story_requests_replies_request.dart';
import 'package:wise_child/features/Settings/data/models/request/get_user_details_request.dart';

import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';

import 'Settings_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: SettingsDatasourceRepo)
class SettingsDatasourceRepoImpl implements SettingsDatasourceRepo {
  final ApiService apiService;
  SettingsDatasourceRepoImpl(this.apiService);
  String userId = CacheService.getData(key: CacheKeys.userId);
  @override
  Future<Result<GetUserDetailsEntity?>> getUserDetails() {
    return executeApi(() async {



      GetUserDetailsRequest getUserDetailsRequest = GetUserDetailsRequest(userId: userId);
      var editProfile = await apiService.getUserDetails(getUserDetailsRequest);
      return editProfile?.toEntity();
    });
  }

  @override
  Future<Result<GetStoryRequestsRepliesEntity?>> getStoryRequestsReplies() {
    return executeApi(() async {


      GetStoryRequestsRepliesRequest getStoryRequestsRepliesRequest = GetStoryRequestsRepliesRequest(userId: userId);

      var response = await apiService.getStoryRequestsWithReplies(getStoryRequestsRepliesRequest);
      return response?.toEntity();

    });
  }
}
