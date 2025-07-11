import 'package:wise_child/features/AllStoriesByUser/data/models/response/user_stories_dto.dart';

class UserStoriesEntity {
  final String? status;

  final String? message;

  final List<ChildrenStoriesData>? childrenStories;

  UserStoriesEntity({this.status, this.message, this.childrenStories});
}
