import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryInfo/data/models/request/story_info_request.dart';

import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';

import 'StoryInfo_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoryInfoDatasourceRepo)
 class StoryInfoDatasourceRepoImpl implements StoryInfoDatasourceRepo {
  final ApiService apiService;
  StoryInfoDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<StoryInfoEntity?>> storyInfo(int storyId) {
  return executeApi(() async{
    StoryInfoRequest storyInfoRequest = StoryInfoRequest(storyId: storyId);
    var response = await apiService.storyInfo(storyInfoRequest);
    return response?.toEntity();

  },);
  }



}
