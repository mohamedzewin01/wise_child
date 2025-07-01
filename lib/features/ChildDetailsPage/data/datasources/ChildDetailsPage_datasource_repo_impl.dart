import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildDetailsPage/data/models/request/children_details_request.dart';

import 'package:wise_child/features/ChildDetailsPage/domain/entities/children_details_entity.dart';

import 'ChildDetailsPage_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ChildDetailsPageDatasourceRepo)
class ChildDetailsPageDatasourceRepoImpl implements ChildDetailsPageDatasourceRepo {
  final ApiService apiService;
  ChildDetailsPageDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<ChildrenDetailsEntity?>> getChildDetails(int childId) {
  return executeApi(() async {
    ChildrenDetailsRequest request = ChildrenDetailsRequest(childId: childId);
    var childrenDetails = await apiService.childrenDetails(request);
    return childrenDetails?.toEntity();
  });
  }
}
