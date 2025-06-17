import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';

import 'Stories_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoriesDatasourceRepo)
class StoriesDatasourceRepoImpl implements StoriesDatasourceRepo {
  final ApiService apiService;
  StoriesDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<ChildrenStoriesEntity?>> getStoriesChildren(int idChildren) {
  return executeApi(() async {
    var stories = await apiService.getChildrenStories(idChildren.toString());
    return stories?.toEntity();
  });
  }
}
