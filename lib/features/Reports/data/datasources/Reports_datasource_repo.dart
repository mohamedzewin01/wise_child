import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Reports/domain/entities/reports_entities.dart';

abstract class ReportsDatasourceRepo {
  Future<Result<ReportsEntity?>>childrenReports();

}
