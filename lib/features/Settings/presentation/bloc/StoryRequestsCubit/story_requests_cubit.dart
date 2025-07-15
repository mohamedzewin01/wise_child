import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';
import 'package:wise_child/features/Settings/domain/useCases/Settings_useCase_repo.dart';

part 'story_requests_state.dart';


@injectable
class StoryRequestsCubit extends Cubit<StoryRequestsState> {
  StoryRequestsCubit(this._settingsUseCaseRepo) : super(StoryRequestsInitial());
  final SettingsUseCaseRepo _settingsUseCaseRepo;

  static StoryRequestsCubit get(context) => BlocProvider.of(context);



  Future<void> getStoryRequests() async {
    emit(StoryRequestsLoading());
    final result = await _settingsUseCaseRepo.getStoryRequestsReplies();
    switch (result) {
      case Success<GetStoryRequestsRepliesEntity?>():
        {
          if (!isClosed) {
            emit(StoryRequestsSuccess(result.data!));
          }
        }
        break;
      case Fail<GetStoryRequestsRepliesEntity?>():
        {
          if (!isClosed) {
            emit(StoryRequestsFailure(result.exception));
          }
        }
    }
  }


}