import 'EditProfile_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: EditProfileDatasourceRepo)
class EditProfileDatasourceRepoImpl implements EditProfileDatasourceRepo {
  final ApiService apiService;
  EditProfileDatasourceRepoImpl(this.apiService);
}
