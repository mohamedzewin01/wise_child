import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';

import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';

import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';

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

    String userId = await CacheService.getData(key: CacheKeys.userId);

    GetChildrenRequest getChildrenRequest = GetChildrenRequest(userId:userId );
    var children = await apiService.getChildrenByUser(getChildrenRequest);
    return children?.toEntity();
  },);
  }

  @override
  Future<Result<DeleteChildrenEntity?>> deleteChildren(DeleteChildrenRequest deleteChildrenRequest) {
   return executeApi(() async{
     var children = await apiService.deleteChildren(deleteChildrenRequest);
     return children?.toEntity();
   },);
  }
}
