import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Analysis/domain/entities/analysis_entities.dart';

abstract class AnalysisDatasourceRepo {
  Future<Result<AddViewStoryEntity?>>addStoryView(int storyId, int childId);

}
