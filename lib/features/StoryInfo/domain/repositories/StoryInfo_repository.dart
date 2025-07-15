import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';

abstract class StoryInfoRepository {
  Future<Result<StoryInfoEntity?>>storyInfo(int storyId);

}
