import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/useCases/SelectStoriesScreen_useCase_repo.dart';

part 'save_story_state.dart';

@injectable
class SaveStoryCubit extends Cubit<SaveStoryState> {
  SaveStoryCubit(this._selectStoriesScreenUseCaseRepo)
    : super(SaveStoryInitial());
  final SelectStoriesScreenUseCaseRepo _selectStoriesScreenUseCaseRepo;
static SaveStoryCubit get(context) => BlocProvider.of(context);
  Future<void> saveStory({
    required int storyId,
    required int childrenId,
    required int problemId,
  }) async {
    emit(SaveStoryLoading());
    SaveStoryRequest saveStoryRequest = SaveStoryRequest(
      userId: CacheService.getData(key: CacheKeys.userId),
      childrenId: childrenId,
      problemId: problemId,
      storiesId: storyId,
    );
    final result = await _selectStoriesScreenUseCaseRepo.saveChildrenStories(
      saveStoryRequest,
    );
    switch (result) {
      case Success<SaveStoryEntity?>():
        {
          if (!isClosed) {
            emit(SaveStorySuccess(result.data!));
          }
        }
        break;
      case Fail<SaveStoryEntity?>():
        {
          if (!isClosed) {
            emit(SaveStoryFailure(result.exception));
          }
        }
        break;
    }
  }
}
