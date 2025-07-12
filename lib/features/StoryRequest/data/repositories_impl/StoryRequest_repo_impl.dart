import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryRequest/data/datasources/StoryRequest_datasource_repo.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/add_story_requests_model.dart';
import 'package:wise_child/features/StoryRequest/domain/entities/story_request_entities.dart';
import '../../domain/repositories/StoryRequest_repository.dart';

@Injectable(as: StoryRequestRepository)
class StoryRequestRepositoryImpl implements StoryRequestRepository {
  final StoryRequestDatasourceRepo storyRequestDatasourceRepo;
  StoryRequestRepositoryImpl(this.storyRequestDatasourceRepo);

  @override
  Future<Result<AddStoryRequestsEntity?>> addStoryRequest(AddStoryRequestsModel addStoryRequestsModel) {
 return storyRequestDatasourceRepo.addStoryRequest(addStoryRequestsModel);
  }

  @override
  Future<Result<GetUserChildrenEntity?>> getChildrenUser() {
  return storyRequestDatasourceRepo.getChildrenUser();
  }

}
