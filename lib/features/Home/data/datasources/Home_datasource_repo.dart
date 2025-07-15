import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Home/domain/entities/home_entity.dart';

abstract class HomeDatasourceRepo {
  Future<Result<AppStatusEntity?>>getAppStatus();
  Future<Result<GetHomeEntity?>>getHomeData();

}
