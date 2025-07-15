import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';

import '../repositories/StoriesUnderCategory_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/StoriesUnderCategory_useCase_repo.dart';

@Injectable(as: StoriesUnderCategoryUseCaseRepo)
class StoriesUnderCategoryUseCase implements StoriesUnderCategoryUseCaseRepo {
  final StoriesUnderCategoryRepository repository;

  StoriesUnderCategoryUseCase(this.repository);

  @override
  Future<Result<StoriesUnderCategoryEntity?>> getStoriesUnderCategory(int categoryId) {
   return repository.getStoriesUnderCategory(categoryId);
  }


}
