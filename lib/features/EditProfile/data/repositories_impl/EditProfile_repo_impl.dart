import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/EditProfile/data/datasources/EditProfile_datasource_repo.dart';
import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';
import '../../domain/repositories/EditProfile_repository.dart';

@Injectable(as: EditProfileRepository)
class EditProfileRepositoryImpl implements EditProfileRepository {
  final EditProfileDatasourceRepo editProfileDatasourceRepo;
  EditProfileRepositoryImpl(this.editProfileDatasourceRepo);
  @override
  Future<Result<EditProfileEntity?>> editProfile(EditProfileRequest editProfileRequest) {
    return editProfileDatasourceRepo.editProfile(editProfileRequest);
  }

}
