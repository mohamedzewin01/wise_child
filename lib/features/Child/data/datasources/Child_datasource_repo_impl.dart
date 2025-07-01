import 'Child_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ChildDatasourceRepo)
class ChildDatasourceRepoImpl implements ChildDatasourceRepo {
  final ApiService apiService;
  ChildDatasourceRepoImpl(this.apiService);
}
