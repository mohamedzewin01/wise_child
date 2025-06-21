



import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';

class StoryPlayEntity {

  final String? status;

  final List<Clips>? clips;

  StoryPlayEntity ({
    this.status,
    this.clips,
  });


}

// class StoryPlayEntity {
//   final String? status;
//   final List<ClipEntity>? clips;
//
//   const StoryPlayEntity({
//     this.status,
//     this.clips,
//   });
// }
//
// class ClipEntity {
//
//
//
//   final String? imageUrl;
//
//   final String? clipText;
//
//
//
//   ClipEntity ({
//
//     this.imageUrl,
//     this.clipText,
//
//   });
//
//
// }