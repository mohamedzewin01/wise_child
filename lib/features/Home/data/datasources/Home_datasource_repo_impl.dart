import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Home/domain/entities/home_entity.dart';

import 'Home_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: HomeDatasourceRepo)
class HomeDatasourceRepoImpl implements HomeDatasourceRepo {
  final ApiService apiService;
  HomeDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetHomeEntity?>> getHomeData() {
return executeApi(() async{
  var result= await apiService.getHomeData();
  return result?.toEntity();


},);
  }
}
