  import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';
import 'package:wise_child/features/StoriesPlay/domain/entities/story_entity.dart';
import '../../domain/useCases/StoriesPlay_useCase_repo.dart';

part 'StoriesData_state.dart';

@injectable
class StoriesDataCubit extends Cubit<StoriesDataState> {
  StoriesDataCubit(this._storiesPlayUseCaseRepo) : super(StoriesPlayInitial());
  final StoriesPlayUseCaseRepo _storiesPlayUseCaseRepo;


  Future<void> getStories({required int storyId,required int childId}) async {
    emit(StoriesPlayLoading());
    var storyPlayRequestModel = StoryPlayRequestModel(storyId: storyId,childId:childId);
    var result = await _storiesPlayUseCaseRepo.getClipsStory(storyPlayRequestModel);
    switch (result) {
      case Success<StoryPlayEntity?>():
        {
          if (!isClosed) {
            emit(StoriesPlaySuccess(result.data!));
          }
        }
        break;
      case Fail():
        {
          if (!isClosed) {
            emit(StoriesPlayFailure(result.exception));
          }
        }
        break;
    }
  }

}
