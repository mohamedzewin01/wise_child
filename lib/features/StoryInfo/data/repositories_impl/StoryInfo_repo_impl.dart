import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryInfo/data/datasources/StoryInfo_datasource_repo.dart';
import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';
import '../../domain/repositories/StoryInfo_repository.dart';

@Injectable(as: StoryInfoRepository)
class StoryInfoRepositoryImpl implements StoryInfoRepository {
  final StoryInfoDatasourceRepo storyInfoDatasourceRepo;
  StoryInfoRepositoryImpl(this.storyInfoDatasourceRepo);

  @override
  Future<Result<StoryInfoEntity?>> storyInfo(int storyId) {
 return storyInfoDatasourceRepo.storyInfo(storyId);
  }
  // implementation
}
