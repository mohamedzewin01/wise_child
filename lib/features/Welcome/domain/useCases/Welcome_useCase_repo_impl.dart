import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';

import '../repositories/Welcome_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Welcome_useCase_repo.dart';

@Injectable(as: WelcomeUseCaseRepo)
class WelcomeUseCase implements WelcomeUseCaseRepo {
  final WelcomeRepository repository;

  WelcomeUseCase(this.repository);

  @override
  Future<Result<AppStatusEntity?>> getAppStatus() {
   return repository.getAppStatus();
  }


}
