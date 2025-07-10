import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Analysis/domain/entities/analysis_entities.dart';

import '../repositories/Analysis_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Analysis_useCase_repo.dart';

@Injectable(as: AnalysisUseCaseRepo)
class AnalysisUseCase implements AnalysisUseCaseRepo {
  final AnalysisRepository repository;

  AnalysisUseCase(this.repository);

  @override
  Future<Result<AddViewStoryEntity?>> addStoryView(int storyId, int childId) {
return repository.addStoryView(storyId, childId);
  }


}
