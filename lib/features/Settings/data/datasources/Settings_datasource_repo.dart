import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';

abstract class SettingsDatasourceRepo {

  Future<Result<GetUserDetailsEntity?>>getUserDetails();
  Future<Result<GetStoryRequestsRepliesEntity?>>getStoryRequestsReplies();

}
