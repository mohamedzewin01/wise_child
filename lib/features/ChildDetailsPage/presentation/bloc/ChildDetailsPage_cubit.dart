import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildDetailsPage/domain/entities/children_details_entity.dart';
import '../../domain/useCases/ChildDetailsPage_useCase_repo.dart';

part 'ChildDetailsPage_state.dart';

@injectable
class ChildDetailsCubit extends Cubit<ChildDetailsState> {
  ChildDetailsCubit(this._childDetailsUseCaseRepo) : super(ChildDetailsPageInitial());
  final ChildDetailsPageUseCaseRepo _childDetailsUseCaseRepo;


  Future<void> getChildDetails({required int childId}) async {
    emit(ChildDetailsPageLoading());

      final result = await _childDetailsUseCaseRepo.getChildDetails(childId);
      switch (result) {
        case Success<ChildrenDetailsEntity?>():
          {
            if (!isClosed) {
              emit(ChildDetailsPageSuccess(result.data!));
            }
          }
          break;
        case Fail<ChildrenDetailsEntity?>():
          {
            if (!isClosed) {
              emit(ChildDetailsPageFailure(result.exception));
            }
          }
          break;
      }


  }
}
