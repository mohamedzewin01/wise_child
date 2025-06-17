import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/uses_cases/childern/Children_useCase_repo.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import '../../domain/useCases/Stories_useCase_repo.dart';

part 'Stories_state.dart';

@injectable
class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit(this._storiesUseCaseRepo, this._childrenUseCaseRepo)
    : super(StoriesInitial());
  final StoriesUseCaseRepo _storiesUseCaseRepo;
  final ChildrenUseCaseRepo _childrenUseCaseRepo;

  static StoriesCubit get(context) => BlocProvider.of(context);


  Future<void> getChildrenByUser() async {
    emit(StoriesLoading());
    var result = await _childrenUseCaseRepo.getChildrenByUser();
    switch (result) {
      case Success<GetChildrenEntity?>():
        {
          if (!isClosed) {
            // idChildren = result.data!.children!.first.idChildren!;
            emit(StoriesSuccess(result.data!));
          }
        }
        break;
      case Fail<GetChildrenEntity?>():
        {
          if (!isClosed) {
            emit(StoriesFailure(result.exception));
          }
        }
        break;
    }
  }
}
