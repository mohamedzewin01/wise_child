import 'Store_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoreDatasourceRepo)
class StoreDatasourceRepoImpl implements StoreDatasourceRepo {
  final ApiService apiService;
  StoreDatasourceRepoImpl(this.apiService);
}
