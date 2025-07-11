import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';

abstract class AllStoriesByUserUseCaseRepo {
  Future<Result<UserStoriesEntity?>>getUserStories();
}
