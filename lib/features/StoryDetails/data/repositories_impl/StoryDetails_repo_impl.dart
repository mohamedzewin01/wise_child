import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryDetails/data/datasources/StoryDetails_datasource_repo.dart';
import 'package:wise_child/features/StoryDetails/domain/entities/story_details_entities.dart';
import '../../domain/repositories/StoryDetails_repository.dart';

@Injectable(as: StoryDetailsRepository)
class StoryDetailsRepositoryImpl implements StoryDetailsRepository {

  final StoryDetailsDatasourceRepo datasource;
  StoryDetailsRepositoryImpl(this.datasource);

  @override
  Future<Result<StoryDetailsEntity?>> storyDetails(int storyId) {
  return datasource.storyDetails(storyId);
  }
  // implementation
}
