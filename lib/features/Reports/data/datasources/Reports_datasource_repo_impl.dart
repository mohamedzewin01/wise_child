import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Reports/data/models/request/reports_request.dart';

import 'package:wise_child/features/Reports/domain/entities/reports_entities.dart';

import 'Reports_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ReportsDatasourceRepo)
class ReportsDatasourceRepoImpl implements ReportsDatasourceRepo {
  final ApiService apiService;

  ReportsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<ReportsEntity?>> childrenReports() {
    return executeApi(() async {
      String? userId = CacheService.getData(key: CacheKeys.userId);
      var response = await apiService.childrenViewsReport(
        ReportsRequest(userId: userId),
      );
      return response?.toEntity();
    });
  }
}
