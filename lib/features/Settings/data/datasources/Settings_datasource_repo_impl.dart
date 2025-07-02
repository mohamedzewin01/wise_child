import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Settings/data/models/request/get_user_details_request.dart';

import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';

import 'Settings_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: SettingsDatasourceRepo)
class SettingsDatasourceRepoImpl implements SettingsDatasourceRepo {
  final ApiService apiService;
  SettingsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetUserDetailsEntity?>> getUserDetails() {
    return executeApi(() async {


      String userId = CacheService.getData(key: CacheKeys.userId);
      GetUserDetailsRequest getUserDetailsRequest = GetUserDetailsRequest(userId: userId);
      var editProfile = await apiService.getUserDetails(getUserDetailsRequest);
      return editProfile?.toEntity();
    });
  }
}
