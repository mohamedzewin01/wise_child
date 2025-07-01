import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildDetailsPage/data/datasources/ChildDetailsPage_datasource_repo.dart';
import 'package:wise_child/features/ChildDetailsPage/domain/entities/children_details_entity.dart';
import '../../domain/repositories/ChildDetailsPage_repository.dart';

@Injectable(as: ChildDetailsPageRepository)
class ChildDetailsPageRepositoryImpl implements ChildDetailsPageRepository {
  final ChildDetailsPageDatasourceRepo datasource;
  ChildDetailsPageRepositoryImpl(this.datasource);
  @override
  Future<Result<ChildrenDetailsEntity?>> getChildDetails(int childId) {
  return datasource.getChildDetails(childId);
  }
  // implementation
}
