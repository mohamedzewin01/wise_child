import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';
import '../../domain/useCases/EditProfile_useCase_repo.dart';

part 'EditProfile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._editProfileUseCaseRepo) : super(EditProfileInitial());
  final EditProfileUseCaseRepo _editProfileUseCaseRepo;


  Future<void> editProfile({
    required String firstName,
    required String lastName,
    String? gender,

    required String phone,
    required int age,
    required String password,
    required String confirmPassword,
  }) async {
      emit(EditProfileLoading());
      String? userId = CacheService.getData(key: CacheKeys.userId);
      EditProfileRequest editProfileRequest = EditProfileRequest(
       firstName: firstName,
          lastName:lastName,
        id: userId,
        age: age,
        password:password ,
        gender: gender
      );
   var result =   await _editProfileUseCaseRepo.editProfile(
          editProfileRequest
      );

   switch (result) {
     case Success<EditProfileEntity?>():
       {
         if (!isClosed) {
           emit(EditProfileSuccess(result.data!));
         }
       }
       break;
     case Fail<EditProfileEntity?>():
       {
         if (!isClosed) {
           emit(EditProfileFailure(result.exception));
         }
       }
       break;

   }

  }
}
