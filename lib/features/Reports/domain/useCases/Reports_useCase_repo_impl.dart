import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Reports/domain/entities/reports_entities.dart';

import '../repositories/Reports_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Reports_useCase_repo.dart';

@Injectable(as: ReportsUseCaseRepo)
class ReportsUseCase implements ReportsUseCaseRepo {
  final ReportsRepository repository;

  ReportsUseCase(this.repository);

  @override
  Future<Result<ReportsEntity?>> childrenReports() {
    return repository.childrenReports();
  }
}
