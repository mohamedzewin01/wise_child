import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Reports/domain/entities/reports_entities.dart';
import '../../domain/useCases/Reports_useCase_repo.dart';

part 'Reports_state.dart';

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._reportsUseCaseRepo) : super(ReportsInitial());
  final ReportsUseCaseRepo _reportsUseCaseRepo;

  Future<void> childrenReports() async {
    emit(ReportsLoading());
    final result = await _reportsUseCaseRepo.childrenReports();
    switch (result) {
      case Success<ReportsEntity?>():
        {
          if (!isClosed) {
            emit(ReportsSuccess(result.data!));
          }
        }
        break;
      case Fail<ReportsEntity?>():
        {
          if (!isClosed) {
            emit(ReportsFailure(result.exception));
          }
        }
        break;
    }
  }
}
