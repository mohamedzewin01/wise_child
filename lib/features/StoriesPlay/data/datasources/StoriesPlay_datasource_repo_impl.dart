import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';

import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';

import 'StoriesPlay_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoriesPlayDatasourceRepo)
class StoriesPlayDatasourceRepoImpl implements StoriesPlayDatasourceRepo {
  final ApiService apiService;
  StoriesPlayDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<StoryPlayEntity?>> getClipsStory(StoryPlayRequestModel storyPlayRequestModel) {
    return executeApi(() async {
      var story = await apiService.getClipsStory(storyPlayRequestModel);
      return story?.toEntity();
    });
  }
}
