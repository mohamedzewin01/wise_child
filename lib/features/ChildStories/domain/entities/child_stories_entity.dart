

import 'package:wise_child/features/ChildStories/data/models/response/get_child_stories_dto.dart';

class ChildStoriesEntity {

  final String? status;

  final Child? child;

  final Child? message;

  ChildStoriesEntity ({
    this.status,
    this.message,
    this.child,
  });


}