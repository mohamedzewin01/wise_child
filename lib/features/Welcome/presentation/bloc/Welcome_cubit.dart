import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';
import '../../domain/useCases/Welcome_useCase_repo.dart';

part 'Welcome_state.dart';

@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._welcomeUseCaseRepo) : super(WelcomeInitial());
  static WelcomeCubit get(context) => BlocProvider.of(context);
  final WelcomeUseCaseRepo _welcomeUseCaseRepo;
  Future<void> getAppStatus() async {
    emit(AppStatusLoading());
    var result = await _welcomeUseCaseRepo.getAppStatus();

    switch (result) {
      case Success<AppStatusEntity?>():
        if (!isClosed) {
          final appStatus = result.data!;
          // التحقق من حالة التطبيق
          if (appStatus.data?.isActive == false) {
            // التطبيق في حالة صيانة
            emit(AppMaintenanceState(appStatus));
          } else {
            // التطبيق يعمل بشكل طبيعي
            emit(AppStatusSuccess(appStatus));
          }
        }
        break;
      case Fail<AppStatusEntity?>():
        if (!isClosed) emit(AppStatusFailure(result.exception));
        break;
    }
  }
}
