import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';

import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';

import '../repositories/EditProfile_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/EditProfile_useCase_repo.dart';

@Injectable(as: EditProfileUseCaseRepo)
class EditProfileUseCase implements EditProfileUseCaseRepo {
  final EditProfileRepository repository;

  EditProfileUseCase(this.repository);

  @override
  Future<Result<EditProfileEntity?>> editProfile(EditProfileRequest editProfileRequest) {
 return repository.editProfile(editProfileRequest);
  }

}
