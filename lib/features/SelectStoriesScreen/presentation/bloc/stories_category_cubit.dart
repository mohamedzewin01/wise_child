import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/stories_by_category_entity.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/useCases/SelectStoriesScreen_useCase_repo.dart';

part 'stories_category_state.dart';

@injectable
class StoriesCategoryCubit extends Cubit<StoriesCategoryState> {
  StoriesCategoryCubit(this._selectStoriesScreenUseCaseRepo)
      : super(StoriesCategoryInitial());
  final SelectStoriesScreenUseCaseRepo _selectStoriesScreenUseCaseRepo;
static StoriesCategoryCubit get(context) => BlocProvider.of(context);
  Future<void> getCategoriesStories({
    int? idChildren,
    int? categoryId,
    int? page
  }) async {
    emit(StoriesCategoryLoading());

    final result = await _selectStoriesScreenUseCaseRepo.storiesByCategory(
      idChildren: idChildren,
      categoryId: categoryId,
      page: page ?? 1,
    );

    switch (result) {
      case Success<StoriesByCategoryEntity?>():
        {
          if (!isClosed) {
            emit(StoriesCategorySuccess(result.data!));
          }
        }
        break;
      case Fail<StoriesByCategoryEntity?>():
        {
          if (!isClosed) {
            emit(StoriesCategoryFailure(result.exception));
          }
        }
        break;
    }
  }

  void resetState() {
    emit(StoriesCategoryInitial());
  }
}