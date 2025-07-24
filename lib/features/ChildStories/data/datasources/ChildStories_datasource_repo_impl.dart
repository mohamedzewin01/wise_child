import 'package:injectable/injectable.dart';
import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/api/api_manager/api_manager.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildStories/data/datasources/ChildStories_datasource_repo.dart';
import 'package:wise_child/features/ChildStories/data/models/request/get_child_stories_request.dart';
import 'package:wise_child/features/ChildStories/domain/entities/child_stories_entity.dart';


@Injectable(as: ChildStoriesDatasourceRepo)
class ChildStoriesDatasourceRepoImpl implements ChildStoriesDatasourceRepo {
  final ApiService apiService;

  ChildStoriesDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<ChildStoriesEntity?>> getChildStories(int childId) {
    return executeApi(() async {
      GetChildStoriesRequest getChildrenStoriesRequest = GetChildStoriesRequest(
        childId: childId,
      );
      final response = await apiService.getChildStories(
        getChildrenStoriesRequest,
      );
      return response!.toEntity();
    });
  }
}
