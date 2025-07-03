import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/StoryDetails/domain/entities/story_details_entities.dart';
import '../../domain/useCases/StoryDetails_useCase_repo.dart';

part 'StoryDetails_state.dart';

@injectable
class StoryDetailsCubit extends Cubit<StoryDetailsState> {
  StoryDetailsCubit(this._storyDetailsUseCaseRepo)
    : super(StoryDetailsInitial());
  final StoryDetailsUseCaseRepo _storyDetailsUseCaseRepo;

  static StoryDetailsCubit get(context) => BlocProvider.of(context);

  Future<void> getStoryDetails(int storyId) async {
    emit(StoryDetailsLoading());
    final result = await _storyDetailsUseCaseRepo.storyDetails(storyId);
    switch (result) {
      case Success<StoryDetailsEntity?>():
        {
          if (!isClosed) {
            // idChildren = result.data!.children!.first.idChildren!;
            emit(StoryDetailsSuccess(result.data!));
          }
        }
        break;
      case Fail<StoryDetailsEntity?>():
        {
          if (!isClosed) {
            emit(StoryDetailsFailure(result.exception));
          }
        }
        break;
    }
  }
}
