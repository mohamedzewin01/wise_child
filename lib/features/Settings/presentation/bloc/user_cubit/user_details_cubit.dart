import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';
import 'package:wise_child/features/Settings/domain/useCases/Settings_useCase_repo.dart';

part 'user_details_state.dart';

@injectable
class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit(this._settingsUseCaseRepo) : super(UserDetailsInitial());

  final SettingsUseCaseRepo _settingsUseCaseRepo;

  static UserDetailsCubit get(context) => BlocProvider.of(context);


  Future<void> getUserDetails() async {
    emit(UserDetailsLoading());
    final result = await _settingsUseCaseRepo.getUserDetails();
    switch (result) {
      case Success<GetUserDetailsEntity?>():
        {
          if (!isClosed) {
            emit(UserDetailsSuccess(result.data!));
          }
        }
        break;
      case Fail<GetUserDetailsEntity?>():
        {
          if (!isClosed) {
            emit(UserDetailsFailure(result.exception));
          }
        }
        break;
    }
  }
}