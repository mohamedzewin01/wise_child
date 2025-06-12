import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/AddChildren/domain/entities/add_entity.dart';
import '../../domain/useCases/AddChildren_useCase_repo.dart';

part 'AddChildren_state.dart';

@injectable
class AddChildrenCubit extends Cubit<AddChildrenState> {
  AddChildrenCubit(this._addChildrenUseCaseRepo) : super(AddChildrenInitial());
  final AddChildrenUseCaseRepo _addChildrenUseCaseRepo;

  static AddChildrenCubit get(context) => BlocProvider.of(context);


  Future<void> addChild(AddChildRequest addChildRequest) async {
    emit(AddChildrenLoading());
    final result = await _addChildrenUseCaseRepo.addChild(addChildRequest);
    switch (result) {
      case Success<AddChildEntity?>():
        {
          if (!isClosed) {
            emit(AddChildrenSuccess(result.data!));
          }
        }
        break;
      case Fail<AddChildEntity?>():
        {
          if (!isClosed) {
            emit(AddChildrenFailure(result.exception));
          }
        }
        break;
    }
  }


}
