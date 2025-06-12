import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/AddChildren/data/datasources/AddChildren_datasource_repo.dart';
import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/AddChildren/domain/entities/add_entity.dart';
import '../../domain/repositories/AddChildren_repository.dart';

@Injectable(as: AddChildrenRepository)
class AddChildrenRepositoryImpl implements AddChildrenRepository {
  final AddChildrenDatasourceRepo addChildrenDatasourceRepo;
  AddChildrenRepositoryImpl(this.addChildrenDatasourceRepo);
  @override
  Future<Result<AddChildEntity?>> addChild(AddChildRequest addChildRequest) {
  return addChildrenDatasourceRepo.addChild(addChildRequest);
  }
  // implementation
}
