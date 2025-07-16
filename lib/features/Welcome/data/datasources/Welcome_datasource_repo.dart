import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';

abstract class WelcomeDatasourceRepo {
  Future<Result<AppStatusEntity?>>getAppStatus();
}
