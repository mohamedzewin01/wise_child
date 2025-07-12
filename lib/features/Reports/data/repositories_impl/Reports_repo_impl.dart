import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Reports/data/datasources/Reports_datasource_repo.dart';
import 'package:wise_child/features/Reports/domain/entities/reports_entities.dart';
import '../../domain/repositories/Reports_repository.dart';

@Injectable(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsDatasourceRepo reportsDatasourceRepo;
  ReportsRepositoryImpl(this.reportsDatasourceRepo);

  @override
  Future<Result<ReportsEntity?>> childrenReports() {
    return reportsDatasourceRepo.childrenReports();
  }

}
