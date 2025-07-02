import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';

import '../repositories/Settings_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Settings_useCase_repo.dart';

@Injectable(as: SettingsUseCaseRepo)
class SettingsUseCase implements SettingsUseCaseRepo {
  final SettingsRepository repository;

  SettingsUseCase(this.repository);

  @override
  Future<Result<GetUserDetailsEntity?>> getUserDetails() {
 return repository.getUserDetails();
  }


}
