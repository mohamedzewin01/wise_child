import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Home/data/datasources/Home_datasource_repo.dart';
import 'package:wise_child/features/Home/domain/entities/home_entity.dart';
import '../../domain/repositories/Home_repository.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
final HomeDatasourceRepo homeDatasourceRepo;
HomeRepositoryImpl(this.homeDatasourceRepo);

  @override
  Future<Result<GetHomeEntity?>> getHomeData() {
    return homeDatasourceRepo.getHomeData();
  }
}
