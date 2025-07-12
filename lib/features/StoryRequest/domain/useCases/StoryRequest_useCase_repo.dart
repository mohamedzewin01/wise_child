import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/add_story_requests_model.dart';
import 'package:wise_child/features/StoryRequest/domain/entities/story_request_entities.dart';

abstract class StoryRequestUseCaseRepo {

  Future<Result<GetUserChildrenEntity?>> getChildrenUser();
  Future<Result<AddStoryRequestsEntity?>> addStoryRequest(AddStoryRequestsModel addStoryRequestsModel);
}
