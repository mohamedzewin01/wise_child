// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:injectable/injectable.dart';
// import 'package:wise_child/core/common/api_result.dart';
// import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';
// import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
// import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';
// import '../../../../core/uses_cases/childern/Children_useCase_repo.dart';
//
// part 'Children_state.dart';
//
//
//
// @injectable
// class ChildrenCubit extends Cubit<ChildrenState> {
//   ChildrenCubit(this._childrenUseCaseRepo) : super(ChildrenInitial());
//
//   final ChildrenUseCaseRepo _childrenUseCaseRepo;
//
//   GetChildrenEntity? _childrenList;
//
//   Future<void> getChildrenByUser() async {
//     emit(ChildrenLoading());
//     var result = await _childrenUseCaseRepo.getChildrenByUser();
//     switch (result) {
//       case Success<GetChildrenEntity?>():
//         {
//           if (!isClosed) {
//             _childrenList = result.data;
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
//
//   Future<void> deleteChild(int childId) async {
//
//     DeleteChildrenRequest childIdRequest = DeleteChildrenRequest(idChildren: childId);
//     var result = await _childrenUseCaseRepo.deleteChildren(childIdRequest);
//
//     switch (result) {
//       case Success<DeleteChildrenEntity?>():
//         {
//           if (!isClosed) {
//
//             _childrenList?.children?.removeWhere((child) => child.idChildren == childId);
//
//             // إرسال الحالة الجديدة بعد الحذف
//             emit(DeleteChildrenSuccess(result.data!));
//             emit(ChildrenSuccess(_childrenList!));
//           }
//         }
//         break;
//
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

///
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';
import '../../../../core/uses_cases/childern/Children_useCase_repo.dart';

part 'Children_state.dart';

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
    // Show loading state for the specific child being deleted
    emit(DeleteChildrenLoading());

    DeleteChildrenRequest childIdRequest = DeleteChildrenRequest(idChildren: childId);
    var result = await _childrenUseCaseRepo.deleteChildren(childIdRequest);

    switch (result) {
      case Success<DeleteChildrenEntity?>():
        {
          if (!isClosed) {
            // Remove from local list only after successful API call
            _childrenList?.children?.removeWhere((child) => child.idChildren == childId);

            // Emit success state for delete operation
            emit(DeleteChildrenSuccess(result.data!));

            // Immediately emit updated children list
            if (_childrenList != null) {
              emit(ChildrenSuccess(_childrenList!));
            }
          }
        }
        break;

      case Fail<DeleteChildrenEntity?>():
        {
          if (!isClosed) {
            emit(DeleteChildrenFailure(result.exception));
            // Re-emit the current children list to maintain state
            if (_childrenList != null) {
              emit(ChildrenSuccess(_childrenList!));
            }
          }
        }
        break;
    }
  }


  // Method to refresh children list after delete
  Future<void> refreshChildren() async {
    await getChildrenByUser();
  }

  // Get current children count
  int get childrenCount => _childrenList?.children?.length ?? 0;

  // Check if a child exists
  bool hasChild(int childId) {
    return _childrenList?.children?.any((child) => child.idChildren == childId) ?? false;
  }
}