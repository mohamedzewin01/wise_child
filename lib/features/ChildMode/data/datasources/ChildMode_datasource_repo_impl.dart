import 'ChildMode_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ChildModeDatasourceRepo)
class ChildModeDatasourceRepoImpl implements ChildModeDatasourceRepo {
  final ApiService apiService;
  ChildModeDatasourceRepoImpl(this.apiService);
}
