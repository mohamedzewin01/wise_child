import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';

import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';

import 'EditProfile_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: EditProfileDatasourceRepo)
class EditProfileDatasourceRepoImpl implements EditProfileDatasourceRepo {
  final ApiService apiService;

  EditProfileDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<EditProfileEntity?>> editProfile(
    EditProfileRequest editProfileRequest,
  ) {
    return executeApi(() async {
      var editProfile = await apiService.editProfile(editProfileRequest);
      return editProfile?.toEntity();
    });
  }
}
