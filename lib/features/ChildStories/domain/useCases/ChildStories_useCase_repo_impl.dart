import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/ChildStories/domain/entities/child_stories_entity.dart';

import '../repositories/ChildStories_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ChildStories_useCase_repo.dart';

@Injectable(as: ChildStoriesUseCaseRepo)
class ChildStoriesUseCase implements ChildStoriesUseCaseRepo {
  final ChildStoriesRepository repository;

  ChildStoriesUseCase(this.repository);

  @override
  Future<Result<ChildStoriesEntity?>> getChildStories(int childId) {
   return repository.getChildStories(childId);
  }

}
