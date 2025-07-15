import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Home/domain/entities/home_entity.dart';

import '../repositories/Home_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Home_useCase_repo.dart';

@Injectable(as: HomeUseCaseRepo)
class HomeUseCase implements HomeUseCaseRepo {
  final HomeRepository repository;

  HomeUseCase(this.repository);

  @override
  Future<Result<GetHomeEntity?>> getHomeData() {
 return repository.getHomeData();
  }

  @override
  Future<Result<AppStatusEntity?>> getAppStatus() {
  return repository.getAppStatus();
  }


}
