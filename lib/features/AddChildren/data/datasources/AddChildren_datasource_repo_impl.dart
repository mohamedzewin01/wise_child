import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';

import 'package:wise_child/features/AddChildren/domain/entities/add_entity.dart';

import 'AddChildren_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: AddChildrenDatasourceRepo)
class AddChildrenDatasourceRepoImpl implements AddChildrenDatasourceRepo {
  final ApiService apiService;
  AddChildrenDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddChildEntity?>> addChild(AddChildRequest addChildRequest) {
    return executeApi(() async {
      var addChild = await apiService.addChild(addChildRequest);
      return addChild?.toEntity();
    });
  }
}
