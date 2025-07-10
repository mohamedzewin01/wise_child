import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Home/domain/entities/home_entity.dart';
import 'package:wise_child/features/Home/domain/useCases/Home_useCase_repo.dart';

part 'get_home_state.dart';
@injectable
class GetHomeCubit extends Cubit<GetHomeState> {
  GetHomeCubit(this._homeUseCaseRepo) : super(GetHomeInitial());
  final HomeUseCaseRepo _homeUseCaseRepo;

  Future<void> getHomeData() async {
    emit(HomeLoading());
    var result = await _homeUseCaseRepo.getHomeData();
    switch (result) {
      case Success<GetHomeEntity?>():
        if (!isClosed) emit(HomeSuccess(result.data!));
        break;
      case Fail<GetHomeEntity?>():
        if (!isClosed) emit(HomeFailure(result.exception));
        break;
    }
  }
}
