import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';
import '../../domain/useCases/Children_useCase_repo.dart';

part 'Children_state.dart';

// @injectable
// class ChildrenCubit extends Cubit<ChildrenState> {
//   ChildrenCubit(this._childrenUseCaseRepo) : super(ChildrenInitial());
//   final ChildrenUseCaseRepo _childrenUseCaseRepo;
//
//
//
//
//   Future<void> getChildrenByUser() async {
//     emit(ChildrenLoading());
//     var result = await _childrenUseCaseRepo.getChildrenByUser();
//     switch (result) {
//       case Success<GetChildrenEntity?>():
//         {
//           if (!isClosed) {
//             emit(ChildrenSuccess(result.data!));
//           }
//         }
//         break;
//       case Fail<GetChildrenEntity?>():
//         {
//           if (!isClosed) {
//             emit(ChildrenFailure(result.exception));
//           }
//         }
//         break;
//     }
//   }
//   Future<void> deleteChild(int childId) async {
//     emit(DeleteChildrenLoading());
//     DeleteChildrenRequest childIdRequest = DeleteChildrenRequest(idChildren: childId);
//     var result = await _childrenUseCaseRepo.deleteChildren(childIdRequest);
//     switch (result) {
//       case Success<DeleteChildrenEntity?>():
//         {
//           if (!isClosed) {
//             emit(DeleteChildrenSuccess(result.data!));
//           }
//         }
//         break;
//       case Fail<DeleteChildrenEntity?>():
//         {
//           if (!isClosed) {
//             emit(DeleteChildrenFailure(result.exception));
//           }
//         }
//         break;
//     }
//   }
// }

@injectable
class ChildrenCubit extends Cubit<ChildrenState> {
  ChildrenCubit(this._childrenUseCaseRepo) : super(ChildrenInitial());

  final ChildrenUseCaseRepo _childrenUseCaseRepo;

  GetChildrenEntity? _childrenList;

  Future<void> getChildrenByUser() async {
    emit(ChildrenLoading());
    var result = await _childrenUseCaseRepo.getChildrenByUser();
    switch (result) {
      case Success<GetChildrenEntity?>():
        {
          if (!isClosed) {
            _childrenList = result.data;
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

  Future<void> deleteChild(int childId) async {

    DeleteChildrenRequest childIdRequest = DeleteChildrenRequest(idChildren: childId);
    var result = await _childrenUseCaseRepo.deleteChildren(childIdRequest);

    switch (result) {
      case Success<DeleteChildrenEntity?>():
        {
          if (!isClosed) {

            _childrenList?.children?.removeWhere((child) => child.idChildren == childId);

            // إرسال الحالة الجديدة بعد الحذف
            emit(DeleteChildrenSuccess(result.data!));
            emit(ChildrenSuccess(_childrenList!));
          }
        }
        break;

      case Fail<DeleteChildrenEntity?>():
        {
          if (!isClosed) {
            emit(DeleteChildrenFailure(result.exception));
          }
        }
        break;
    }
  }
}
