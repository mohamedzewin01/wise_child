import 'package:wise_child/features/Settings/data/models/response/get_story_requests_replies_dto.dart';
import 'package:wise_child/features/Settings/data/models/response/get_user_details_dto.dart';

class GetUserDetailsEntity{

  final String? status;

  final UserDetail? user;

  GetUserDetailsEntity({
    this.status,
    this.user,
  });


}

class GetStoryRequestsRepliesEntity {

  final String? status;

  final String? message;

  final List<DataStoryRequest>? data;

  GetStoryRequestsRepliesEntity ({
    this.status,
    this.message,
    this.data,
  });


}