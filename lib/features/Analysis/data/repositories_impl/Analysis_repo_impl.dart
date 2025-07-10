import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Analysis/data/datasources/Analysis_datasource_repo.dart';
import 'package:wise_child/features/Analysis/domain/entities/analysis_entities.dart';
import '../../domain/repositories/Analysis_repository.dart';

@Injectable(as: AnalysisRepository)
class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisDatasourceRepo analysisDatasourceRepo;
  AnalysisRepositoryImpl(this.analysisDatasourceRepo);
  @override
  Future<Result<AddViewStoryEntity?>> addStoryView(int storyId, int childId) {
   return analysisDatasourceRepo.addStoryView(storyId, childId);
  }
  // implementation
}
