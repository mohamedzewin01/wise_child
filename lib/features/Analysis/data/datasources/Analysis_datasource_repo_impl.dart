import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Analysis/data/models/request/add_view_story_request.dart';

import 'package:wise_child/features/Analysis/domain/entities/analysis_entities.dart';

import 'Analysis_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: AnalysisDatasourceRepo)
class AnalysisDatasourceRepoImpl implements AnalysisDatasourceRepo {
  final ApiService apiService;

  AnalysisDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddViewStoryEntity?>> addStoryView(int storyId, int childId) {
    return executeApi(() async {
      final response = await apiService.addStoryView(
        AddViewStoryRequest(storyId: storyId, childId: childId),
      );
      return response?.toEntity();
    });
  }
}
