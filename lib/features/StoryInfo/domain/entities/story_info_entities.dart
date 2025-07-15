import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';

class StoryInfoEntity {

  final String? status;

  final String? message;

  final StoryInfo? story;

  StoryInfoEntity ({
    this.status,
    this.message,
    this.story,
  });


}