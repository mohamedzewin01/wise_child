import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/ChildDetailsPage/domain/entities/children_details_entity.dart';

import '../repositories/ChildDetailsPage_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ChildDetailsPage_useCase_repo.dart';

@Injectable(as: ChildDetailsPageUseCaseRepo)
class ChildDetailsPageUseCase implements ChildDetailsPageUseCaseRepo {
  final ChildDetailsPageRepository repository;

  ChildDetailsPageUseCase(this.repository);

  @override
  Future<Result<ChildrenDetailsEntity?>> getChildDetails(int childId) {
   return repository.getChildDetails(childId);
  }


}
