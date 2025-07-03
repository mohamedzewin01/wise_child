import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryDetails/domain/entities/story_details_entities.dart';

abstract class StoryDetailsDatasourceRepo {
  Future<Result<StoryDetailsEntity?>>storyDetails(int storyId,int childId);

}
