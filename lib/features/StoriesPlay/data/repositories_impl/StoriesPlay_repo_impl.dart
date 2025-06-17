import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesPlay/data/datasources/StoriesPlay_datasource_repo.dart';
import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';
import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';
import '../../domain/repositories/StoriesPlay_repository.dart';

@Injectable(as: StoriesPlayRepository)
class StoriesPlayRepositoryImpl implements StoriesPlayRepository {
  final StoriesPlayDatasourceRepo datasource;
  StoriesPlayRepositoryImpl(this.datasource);
  @override
  Future<Result<StoryPlayEntity?>> getClipsStory(StoryPlayRequestModel storyPlayRequestModel) {
   return datasource.getClipsStory(storyPlayRequestModel);
  }
  // implementation
}
