import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/StoryRequest/data/models/request/add_story_requests_model.dart';

import 'package:wise_child/features/StoryRequest/domain/entities/story_request_entities.dart';

import '../repositories/StoryRequest_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/StoryRequest_useCase_repo.dart';

@Injectable(as: StoryRequestUseCaseRepo)
class StoryRequestUseCase implements StoryRequestUseCaseRepo {
  final StoryRequestRepository repository;

  StoryRequestUseCase(this.repository);

  @override
  Future<Result<AddStoryRequestsEntity?>> addStoryRequest(AddStoryRequestsModel addStoryRequestsModel) {
 return repository.addStoryRequest(addStoryRequestsModel);
  }

  @override
  Future<Result<GetUserChildrenEntity?>> getChildrenUser() {
    return repository.getChildrenUser();
  }


}
