import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Auth/domain/entities/user_entity.dart';
import '../../domain/useCases/Auth_useCase_repo.dart';

part 'Auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authUseCaseRepo) : super(AuthInitial());
  final AuthUseCaseRepo _authUseCaseRepo;


  Future<void> signIn({required String email, required String password}) async{
    emit(AuthLoginLoading());
    final result = await _authUseCaseRepo.signIn(email, password);
    switch (result) {
      case Success<UserSignUpEntity?>():
        {
          if (!isClosed) {
            CacheService.setData(key: CacheKeys.userId, value: result.data!.user?.id);
            CacheService.setData(key: CacheKeys.userPhoto, value: result.data!.user?.profileImage);
            CacheService.setData(key: CacheKeys.userFirstName, value: result.data!.user?.firstName);
            CacheService.setData(key: CacheKeys.userLastName, value: result.data!.user?.lastName);
            CacheService.setData(key: CacheKeys.userEmail, value: result.data!.user?.email);
            CacheService.setData(key: CacheKeys.userAge, value: result.data!.user?.age);
            CacheService.setData(key: CacheKeys.userGender, value: result.data!.user?.gender);
            CacheService.setData(key: CacheKeys.userActive, value: true);
            emit(AuthLoginSuccess(result.data!));
          }
        }
        break;
      case Fail<UserSignUpEntity?>():
        {
          if (!isClosed) {
            emit(AuthLoginFailure(result.exception));
          }
        }
        break;
    }
  }
  Future<void> signUp({required String firstName,required String lastName,required String email, required String password}) async{
    emit(AuthSingUpLoading());
    final result = await _authUseCaseRepo.signUp(firstName, lastName, email, password);
    switch (result) {
      case Success<UserSignUpEntity?>():
        {
          if (!isClosed) {
            CacheService.setData(key: CacheKeys.userId, value: result.data!.user?.id);
            CacheService.setData(key: CacheKeys.userPhoto, value: result.data!.user?.profileImage);
            CacheService.setData(key: CacheKeys.userFirstName, value: result.data!.user?.firstName);
            CacheService.setData(key: CacheKeys.userLastName, value: result.data!.user?.lastName);
            CacheService.setData(key: CacheKeys.userEmail, value: result.data!.user?.email);
            CacheService.setData(key: CacheKeys.userAge, value: result.data!.user?.age);
            CacheService.setData(key: CacheKeys.userGender, value: result.data!.user?.gender);
            CacheService.setData(key: CacheKeys.userActive, value: true);
            emit(AuthSingUpSuccess(result.data!));
          }
        }
        break;
      case Fail<UserSignUpEntity?>():
        {
          if (!isClosed) {
            emit(AuthSingUpFailure(result.exception));
          }
        }
        break;
    }
  }
  Future<void> signInWithGoogle() async{
    emit(AuthLoginLoading());
    final result = await _authUseCaseRepo.signInWithGoogle();
    switch (result) {
      case Success<UserSignUpEntity?>():
        {
          if (!isClosed) {
            CacheService.setData(key: CacheKeys.userId, value: result.data!.user?.id);
            CacheService.setData(key: CacheKeys.userPhoto, value: result.data!.user?.profileImage);
            CacheService.setData(key: CacheKeys.userFirstName, value: result.data!.user?.firstName);
            CacheService.setData(key: CacheKeys.userLastName, value: result.data!.user?.lastName);
            CacheService.setData(key: CacheKeys.userEmail, value: result.data!.user?.email);
            CacheService.setData(key: CacheKeys.userAge, value: result.data!.user?.age);
            CacheService.setData(key: CacheKeys.userGender, value: result.data!.user?.gender);
            CacheService.setData(key: CacheKeys.userActive, value: true);
            emit(AuthLoginSuccess(result.data!));
          }
        }
        break;
      case Fail<UserSignUpEntity?>():
        {
          if (!isClosed) {
            emit(AuthLoginFailure(result.exception));
          }
        }
        break;
    }
  }


}
