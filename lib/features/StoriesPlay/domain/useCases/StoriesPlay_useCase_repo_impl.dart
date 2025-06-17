import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';

import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';

import '../repositories/StoriesPlay_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/StoriesPlay_useCase_repo.dart';

@Injectable(as: StoriesPlayUseCaseRepo)
class StoriesPlayUseCase implements StoriesPlayUseCaseRepo {
  final StoriesPlayRepository repository;

  StoriesPlayUseCase(this.repository);

  @override
  Future<Result<StoryPlayEntity?>> getClipsStory(StoryPlayRequestModel storyPlayRequestModel) {
  return repository.getClipsStory(storyPlayRequestModel);
  }


}
