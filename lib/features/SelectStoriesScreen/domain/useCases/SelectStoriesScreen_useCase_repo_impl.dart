import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';

import '../repositories/SelectStoriesScreen_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/SelectStoriesScreen_useCase_repo.dart';

@Injectable(as: SelectStoriesScreenUseCaseRepo)
class SelectStoriesScreenUseCase implements SelectStoriesScreenUseCaseRepo {
  final SelectStoriesScreenRepository repository;

  SelectStoriesScreenUseCase(this.repository);

  @override
  Future<Result<GetCategoriesStoriesEntity?>> getCategoriesStories() {
    return repository.getCategoriesStories();
  }

  @override
  Future<Result<StoriesByCategoryEntity?>> storiesByCategory({
    int? categoryId,
    int? idChildren,
    int? page,
  }) {
    return repository.storiesByCategory(
      categoryId: categoryId,
      idChildren: idChildren,
      page: page,
    );
  }
}
