import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryInfo/domain/entities/story_info_entities.dart';
import '../../domain/useCases/StoryInfo_useCase_repo.dart';

part 'StoryInfo_state.dart';

@injectable
class StoryInfoCubit extends Cubit<StoryInfoState> {
  StoryInfoCubit(this._storyInfoUseCaseRepo) : super(StoryInfoInitial());
  final StoryInfoUseCaseRepo _storyInfoUseCaseRepo;
  Future<void> storyInfo(int storyId) async {
    emit(StoryInfoLoading());
    var result = await _storyInfoUseCaseRepo.storyInfo(storyId);
    switch (result) {
      case Success<StoryInfoEntity?>():
        {
          if (!isClosed) {
            emit(StoryInfoSuccess(result.data!));
          }
        }
        break;
      case Fail<StoryInfoEntity?>():
        {
          if (!isClosed) {
            emit(StoryInfoFailure(result.exception));
          }
        }
        break;
    }

  }
}
