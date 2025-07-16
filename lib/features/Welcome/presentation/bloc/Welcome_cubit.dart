import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';
import '../../domain/useCases/Welcome_useCase_repo.dart';

part 'Welcome_state.dart';

@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._welcomeUseCaseRepo) : super(WelcomeInitial());
  final WelcomeUseCaseRepo _welcomeUseCaseRepo;
  Future<void> getAppStatus() async {
    emit(AppStatusLoading());
    var result = await _welcomeUseCaseRepo.getAppStatus();

    switch (result) {
      case Success<AppStatusEntity?>():
        if (!isClosed) emit(AppStatusSuccess(result.data!));
        break;
      case Fail<AppStatusEntity?>():
        if (!isClosed) emit(AppStatusFailure(result.exception));
        break;
    }
  }
}
