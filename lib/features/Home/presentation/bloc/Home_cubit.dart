import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Home/domain/entities/home_entity.dart';
import '../../domain/useCases/Home_useCase_repo.dart';

part 'Home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeUseCaseRepo) : super(HomeInitial());
  final HomeUseCaseRepo _homeUseCaseRepo;
  Future<void> getHomeData() async {
    emit(HomeLoading());
    var result = await _homeUseCaseRepo.getHomeData();
    switch (result) {
      case Success<GetHomeEntity?>():
        {
          if (!isClosed) {
            // idChildren = result.data!.children!.first.idChildren!;
            emit(HomeSuccess(result.data!));
          }
        }
        break;
      case Fail<GetHomeEntity?>():
        {
          if (!isClosed) {
            emit(HomeFailure(result.exception));
          }
        }
        break;
    }
  }
}
