import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';

import 'Welcome_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: WelcomeDatasourceRepo)
class WelcomeDatasourceRepoImpl implements WelcomeDatasourceRepo {
  final ApiService apiService;
  WelcomeDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AppStatusEntity?>> getAppStatus() {
    return executeApi(() async {
      var result = await apiService.getAppStatus();
      return result?.toEntity();
    });
  }
}
