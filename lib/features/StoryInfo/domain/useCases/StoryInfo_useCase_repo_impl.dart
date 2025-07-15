import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';

import '../repositories/StoryInfo_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/StoryInfo_useCase_repo.dart';

@Injectable(as: StoryInfoUseCaseRepo)
class StoryInfoUseCase implements StoryInfoUseCaseRepo {
  final StoryInfoRepository repository;

  StoryInfoUseCase(this.repository);

  @override
  Future<Result<StoryInfoEntity?>> storyInfo(int storyId) {
    return repository.storyInfo(storyId);
  }

}
