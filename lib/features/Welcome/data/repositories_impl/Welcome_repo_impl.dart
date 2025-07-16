import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Welcome/data/datasources/Welcome_datasource_repo.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';
import '../../domain/repositories/Welcome_repository.dart';

@Injectable(as: WelcomeRepository)
class WelcomeRepositoryImpl implements WelcomeRepository {
final WelcomeDatasourceRepo welcomeDatasourceRepo;
WelcomeRepositoryImpl(this.welcomeDatasourceRepo);


  @override
  Future<Result<AppStatusEntity?>> getAppStatus() {
    return welcomeDatasourceRepo.getAppStatus();
  }
}
