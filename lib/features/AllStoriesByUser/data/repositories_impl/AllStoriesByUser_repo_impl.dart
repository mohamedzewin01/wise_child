import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/AllStoriesByUser/data/datasources/AllStoriesByUser_datasource_repo.dart';
import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';
import '../../domain/repositories/AllStoriesByUser_repository.dart';

@Injectable(as: AllStoriesByUserRepository)
class AllStoriesByUserRepositoryImpl implements AllStoriesByUserRepository {
  final AllStoriesByUserDatasourceRepo allStoriesByUserDatasourceRepo;
  AllStoriesByUserRepositoryImpl(this.allStoriesByUserDatasourceRepo);

  @override
  Future<Result<UserStoriesEntity?>> getUserStories() {
    return allStoriesByUserDatasourceRepo.getUserStories();
  }


}
