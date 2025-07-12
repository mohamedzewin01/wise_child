import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/add_story_requests_model.dart';
import 'package:wise_child/features/StoryRequest/domain/entities/story_request_entities.dart';
import '../../domain/useCases/StoryRequest_useCase_repo.dart';

part 'StoryRequest_state.dart';

@injectable
class StoryRequestCubit extends Cubit<StoryRequestState> {
  StoryRequestCubit(this._storyRequestUseCaseRepo)
    : super(StoryRequestInitial());
  final StoryRequestUseCaseRepo _storyRequestUseCaseRepo;

  Future<void> getChildrenUser() async {
    emit(GetChildrenUserLoading());
    final result = await _storyRequestUseCaseRepo.getChildrenUser();

    switch (result) {
      case Success<GetUserChildrenEntity?>():
        {
          if (!isClosed) {
            emit(GetChildrenUserSuccess(result.data!));
          }
        }
        break;
      case Fail<GetUserChildrenEntity?>():
        {
          if (!isClosed) {
            emit(GetChildrenUserFailure(result.exception));
          }
        }
        break;
    }
  }

  Future<void> addStoryRequest({
    required String userId,
    required int idChildren,
    required String notes,
    required String problemText,
    required String problemTitle,
  }) async {
    emit(GetChildrenUserLoading());
    AddStoryRequestsModel addStoryRequestsModel = AddStoryRequestsModel(
      userId: CacheService.getData(key: CacheKeys.userId),
      idChildren: idChildren,
      notes: notes,
      problemText: problemText,
      problemTitle: problemTitle,
    );
    final result = await _storyRequestUseCaseRepo.addStoryRequest(
      addStoryRequestsModel,
    );

    switch (result) {
      case Success<AddStoryRequestsEntity?>():
        {
          if (!isClosed) {
            emit(StoryRequestSuccess(result.data!));
          }
        }
        break;
      case Fail<AddStoryRequestsEntity?>():
        {
          if (!isClosed) {
            emit(StoryRequestFailure(result.exception));
          }
        }
        break;
    }
  }
}
