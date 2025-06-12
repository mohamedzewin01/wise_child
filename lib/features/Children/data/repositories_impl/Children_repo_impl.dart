import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/data/datasources/Children_datasource_repo.dart';
import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import '../../domain/repositories/Children_repository.dart';

@Injectable(as: ChildrenRepository)
class ChildrenRepositoryImpl implements ChildrenRepository {
  final ChildrenDatasourceRepo childrenDatasource;

  ChildrenRepositoryImpl(this.childrenDatasource);

  @override
  Future<Result<GetChildrenEntity?>> getChildrenByUser() {
    return childrenDatasource.getChildrenByUser();
  }

  // implementation
}
