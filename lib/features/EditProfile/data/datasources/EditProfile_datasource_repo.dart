import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';

abstract class EditProfileDatasourceRepo {

  Future<Result<EditProfileEntity?>> editProfile(EditProfileRequest editProfileRequest);
}
