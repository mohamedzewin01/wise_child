import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Settings/data/datasources/Settings_datasource_repo.dart';
import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';
import '../../domain/repositories/Settings_repository.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {

  final SettingsDatasourceRepo settingsDatasourceRepo;
  SettingsRepositoryImpl(this.settingsDatasourceRepo);
  @override
  Future<Result<GetUserDetailsEntity?>> getUserDetails() {
   return settingsDatasourceRepo.getUserDetails();
  }

  @override
  Future<Result<GetStoryRequestsRepliesEntity?>> getStoryRequestsReplies() {
   return settingsDatasourceRepo.getStoryRequestsReplies();
  }

}
