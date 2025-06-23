import 'ChildDetailsPage_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ChildDetailsPageDatasourceRepo)
class ChildDetailsPageDatasourceRepoImpl implements ChildDetailsPageDatasourceRepo {
  final ApiService apiService;
  ChildDetailsPageDatasourceRepoImpl(this.apiService);
}
