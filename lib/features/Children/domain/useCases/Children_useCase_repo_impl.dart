import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';

import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';

import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';

import '../repositories/Children_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/uses_cases/childern/Children_useCase_repo.dart';

@Injectable(as: ChildrenUseCaseRepo)
class ChildrenUseCase implements ChildrenUseCaseRepo {
  final ChildrenRepository repository;

  ChildrenUseCase(this.repository);

  @override
  Future<Result<GetChildrenEntity?>> getChildrenByUser() {
    return repository.getChildrenByUser();
  }

  @override
  Future<Result<DeleteChildrenEntity?>> deleteChildren(DeleteChildrenRequest deleteChildrenRequest) {
    return repository.deleteChildren(deleteChildrenRequest);
  }
}
