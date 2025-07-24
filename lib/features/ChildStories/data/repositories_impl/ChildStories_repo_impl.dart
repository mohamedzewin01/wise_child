import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildStories/data/datasources/ChildStories_datasource_repo.dart';
import 'package:wise_child/features/ChildStories/domain/entities/child_stories_entity.dart';
import '../../domain/repositories/ChildStories_repository.dart';

@Injectable(as: ChildStoriesRepository)
class ChildStoriesRepositoryImpl implements ChildStoriesRepository {
  final ChildStoriesDatasourceRepo childStoriesDatasourceRepo;
  ChildStoriesRepositoryImpl(this.childStoriesDatasourceRepo);

  @override
  Future<Result<ChildStoriesEntity?>> getChildStories(int childId) {
    return childStoriesDatasourceRepo.getChildStories(childId);
  }


}
