import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/AllStoriesByUser/domain/entities/all_stories_enities.dart';
import '../../domain/useCases/AllStoriesByUser_useCase_repo.dart';

part 'AllStoriesByUser_state.dart';

@injectable
class AllStoriesByUserCubit extends Cubit<AllStoriesByUserState> {
  AllStoriesByUserCubit(this._allStoriesByUserUseCaseRepo) : super(AllStoriesByUserInitial());
  final AllStoriesByUserUseCaseRepo _allStoriesByUserUseCaseRepo;
  Future<void> getUserStories() async {
    emit(AllStoriesByUserLoading());
    var result = await _allStoriesByUserUseCaseRepo.getUserStories();

    switch (result) {
      case Success<UserStoriesEntity?>():
        {
          if (!isClosed) {

            emit(AllStoriesByUserSuccess(result.data!));
          }
        }
        break;
      case Fail<UserStoriesEntity?>():
        {
          if (!isClosed) {
            emit(AllStoriesByUserFailure(result.exception));
          }
        }
        break;
    }
  }
}
