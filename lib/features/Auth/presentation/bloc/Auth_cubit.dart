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
            CacheService.setData(key: CacheConstants.userId, value: result.data!.user?.id);
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
            CacheService.setData(key: CacheConstants.userId, value: result.data!.user?.id);
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
            CacheService.setData(key: CacheConstants.userId, value: result.data!.user?.id);
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
