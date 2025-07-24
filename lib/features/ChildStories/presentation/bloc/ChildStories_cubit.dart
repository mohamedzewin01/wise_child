import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildStories/domain/entities/child_stories_entity.dart';
import '../../domain/useCases/ChildStories_useCase_repo.dart';

part 'ChildStories_state.dart';

@injectable
class ChildStoriesCubit extends Cubit<ChildStoriesState> {
  ChildStoriesCubit(this._childStoriesUseCaseRepo)
    : super(ChildStoriesInitial());
  final ChildStoriesUseCaseRepo _childStoriesUseCaseRepo;

  Future<void> getChildStories(int childId) async {
    emit(ChildStoriesLoading());

    var result =await _childStoriesUseCaseRepo.getChildStories(childId);
    switch (result) {
      case Success<ChildStoriesEntity?>():
        {
          if (!isClosed) {
            emit(ChildStoriesSuccess(result.data!));
          }
        }
        break;
      case Fail<ChildStoriesEntity?>():
        {
          if (!isClosed) {
            emit(ChildStoriesFailure(result.exception));
          }
        }
        break;
    }
  }
}
