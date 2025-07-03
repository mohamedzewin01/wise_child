import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/StoryDetails/domain/entities/story_details_entities.dart';

import '../repositories/StoryDetails_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/StoryDetails_useCase_repo.dart';

@Injectable(as: StoryDetailsUseCaseRepo)
class StoryDetailsUseCase implements StoryDetailsUseCaseRepo {
  final StoryDetailsRepository repository;

  StoryDetailsUseCase(this.repository);

  @override
  Future<Result<StoryDetailsEntity?>> storyDetails(int storyId) {
return repository.storyDetails(storyId);
  }


}
