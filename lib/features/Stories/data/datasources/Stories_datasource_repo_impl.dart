import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Stories/data/models/request/get_children_stories_request.dart';

import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';

import 'Stories_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoriesDatasourceRepo)
class StoriesDatasourceRepoImpl implements StoriesDatasourceRepo {
  final ApiService apiService;
  StoriesDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<ChildrenStoriesModelEntity?>> getStoriesChildren(int idChildren) {
  return executeApi(() async {
    GetChildrenStoriesRequest request = GetChildrenStoriesRequest(childrenId: idChildren);
    var stories = await apiService.getChildrenStories(request);
    return stories?.toEntity();
  });
  }
}
