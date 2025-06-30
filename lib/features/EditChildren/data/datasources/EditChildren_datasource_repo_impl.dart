import 'EditChildren_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: EditChildrenDatasourceRepo)
class EditChildrenDatasourceRepoImpl implements EditChildrenDatasourceRepo {
  final ApiService apiService;
  EditChildrenDatasourceRepoImpl(this.apiService);
}
