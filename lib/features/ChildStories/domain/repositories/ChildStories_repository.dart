import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildStories/domain/entities/child_stories_entity.dart';

abstract class ChildStoriesRepository {
  Future<Result<ChildStoriesEntity?>>getChildStories(int childId);

}
