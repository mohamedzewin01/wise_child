import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';
import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';

abstract class StoriesPlayRepository {
  Future<Result<StoryPlayEntity?>> getClipsStory(
    StoryPlayRequestModel storyPlayRequestModel,
  );
}
