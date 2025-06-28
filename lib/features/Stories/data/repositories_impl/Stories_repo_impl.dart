import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Stories/data/datasources/Stories_datasource_repo.dart';
import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';
import '../../domain/repositories/Stories_repository.dart';

@Injectable(as: StoriesRepository)
class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesDatasourceRepo datasource;
  StoriesRepositoryImpl(this.datasource);

  @override
  Future<Result<ChildrenStoriesModelEntity?>> getStoriesChildren(int idChildren) {
   return datasource.getStoriesChildren(idChildren);
  }
  // implementation
}
