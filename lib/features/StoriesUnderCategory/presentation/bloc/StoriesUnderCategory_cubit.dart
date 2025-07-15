import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesUnderCategory/domain/entities/stories_under_category_entitiy.dart';
import '../../domain/useCases/StoriesUnderCategory_useCase_repo.dart';

part 'StoriesUnderCategory_state.dart';

@injectable
class StoriesUnderCategoryCubit extends Cubit<StoriesUnderCategoryState> {
  StoriesUnderCategoryCubit(this._storiesUnderCategoryUseCaseRepo) : super(StoriesUnderCategoryInitial());
  final StoriesUnderCategoryUseCaseRepo _storiesUnderCategoryUseCaseRepo;


  Future<void> getStoriesUnderCategory(int categoryId) async {
    emit(StoriesUnderCategoryLoading());
    var result = await _storiesUnderCategoryUseCaseRepo.getStoriesUnderCategory(categoryId);
    switch (result) {
      case Success<StoriesUnderCategoryEntity?>():
        {
          if (!isClosed) {
            emit(StoriesUnderCategorySuccess(result.data!));
          }
        }
        break;
      case Fail<StoriesUnderCategoryEntity?>():
        {
          if (!isClosed) {
            emit(StoriesUnderCategoryFailure(result.exception));
          }
        }
        break;
    }


  }
}
