import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';

import 'package:wise_child/features/AddChildren/domain/entities/add_entity.dart';

import '../repositories/AddChildren_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/AddChildren_useCase_repo.dart';

@Injectable(as: AddChildrenUseCaseRepo)
class AddChildrenUseCase implements AddChildrenUseCaseRepo {
  final AddChildrenRepository repository;

  AddChildrenUseCase(this.repository);

  @override
  Future<Result<AddChildEntity?>> addChild(AddChildRequest addChildRequest) {
   return repository.addChild(addChildRequest);
  }


}
