import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import '../../domain/useCases/Children_useCase_repo.dart';

part 'Children_state.dart';

@injectable
class ChildrenCubit extends Cubit<ChildrenState> {
  ChildrenCubit(this._childrenUseCaseRepo) : super(ChildrenInitial());
  final ChildrenUseCaseRepo _childrenUseCaseRepo;




  Future<void> getChildrenByUser() async {
    emit(ChildrenLoading());
    var result = await _childrenUseCaseRepo.getChildrenByUser();
    switch (result) {
      case Success<GetChildrenEntity?>():
        {
          if (!isClosed) {
            emit(ChildrenSuccess(result.data!));
          }
        }
        break;
      case Fail<GetChildrenEntity?>():
        {
          if (!isClosed) {
            emit(ChildrenFailure(result.exception));
          }
        }
        break;
    }
  }
}
