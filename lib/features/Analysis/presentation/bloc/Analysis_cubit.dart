import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Analysis/domain/entities/analysis_entities.dart';
import '../../domain/useCases/Analysis_useCase_repo.dart';

part 'Analysis_state.dart';

@injectable
class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit(this._analysisUseCaseRepo) : super(AnalysisInitial());
  final AnalysisUseCaseRepo _analysisUseCaseRepo;

static AnalysisCubit get(context) => BlocProvider.of(context);
  Future<void> addStoryView(int storyId, int childId) async {
    emit(AddViewStoryLoading());
    final result = await _analysisUseCaseRepo.addStoryView(storyId, childId);
switch (result) {
  case Success<AddViewStoryEntity?>():
    {
      if (!isClosed) {
        emit(AddViewStorySuccess(result.data!));
      }

    }
case Fail<AddViewStoryEntity?>():
  {
    if (!isClosed) {
      emit(AddViewStoryFailure(result.exception));
    }
  }
}
  }
}
