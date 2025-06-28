import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';

abstract class StoriesUseCaseRepo {
  Future<Result<ChildrenStoriesModelEntity?>> getStoriesChildren(int idChildren);
}
