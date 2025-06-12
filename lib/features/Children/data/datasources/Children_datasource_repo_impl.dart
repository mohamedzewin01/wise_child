import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';

import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';

import 'package:wise_child/features/Children/domain/entities/children_entity.dart';

import 'Children_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ChildrenDatasourceRepo)
class ChildrenDatasourceRepoImpl implements ChildrenDatasourceRepo {
  final ApiService apiService;
  ChildrenDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetChildrenEntity?>> getChildrenByUser() {
  return executeApi(() async{

    String userId = await CacheService.getData(key: CacheConstants.userId);

    GetChildrenRequest getChildrenRequest = GetChildrenRequest(userId:userId );
    var children = await apiService.getChildrenByUser(getChildrenRequest);
    return children?.toEntity();
  },);
  }
}
