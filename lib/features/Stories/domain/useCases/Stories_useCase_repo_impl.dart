import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';

import '../repositories/Stories_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Stories_useCase_repo.dart';

@Injectable(as: StoriesUseCaseRepo)
class StoriesUseCase implements StoriesUseCaseRepo {
  final StoriesRepository repository;

  StoriesUseCase(this.repository);

  @override
  Future<Result<ChildrenStoriesModelEntity?>> getStoriesChildren(int idChildren) {
    return repository.getStoriesChildren(idChildren);
  }
}
