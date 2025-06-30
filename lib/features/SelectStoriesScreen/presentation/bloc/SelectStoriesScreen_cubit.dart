import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import '../../domain/useCases/SelectStoriesScreen_useCase_repo.dart';

part 'SelectStoriesScreen_state.dart';

@injectable
class SelectStoriesScreenCubit extends Cubit<SelectStoriesScreenState> {
  SelectStoriesScreenCubit(this._selectStoriesScreenUseCaseRepo) : super(SelectStoriesScreenInitial());
  final SelectStoriesScreenUseCaseRepo _selectStoriesScreenUseCaseRepo;


  Future<void> getCategoriesStories() async {
    emit(SelectStoriesScreenLoading());
    final result = await _selectStoriesScreenUseCaseRepo.getCategoriesStories();
    switch (result) {
      case Success<GetCategoriesStoriesEntity?>():
        {
          if (!isClosed) {
            emit(SelectStoriesScreenSuccess(result.data!));
          }
        }
        break;
      case Fail<GetCategoriesStoriesEntity?>():
        {
          if (!isClosed) {
            emit(SelectStoriesScreenFailure(result.exception));
          }
        }
        break;
    }

  }
}
