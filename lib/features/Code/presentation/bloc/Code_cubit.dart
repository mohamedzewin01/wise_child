import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Code/domain/entities/code_entities.dart';
import '../../domain/useCases/Code_useCase_repo.dart';

part 'Code_state.dart';

@injectable
class CodeCubit extends Cubit<CodeState> {
  CodeCubit(this._codeUseCaseRepo) : super(CodeInitial());
  final CodeUseCaseRepo _codeUseCaseRepo;



  Future<void> checkCode(String? code) async {
    String? myCode = CacheService.getData(key: CacheKeys.code)??code;
    emit(CodeLoading());
    final result = await _codeUseCaseRepo.checkCode(myCode);

  switch (result) {
    case Success<CheckCodeEntity?>():
      CacheService.setData(key: CacheKeys.code, value: code);
      CacheService.setData(key: CacheKeys.codeActive, value: true);
      emit(CodeSuccess(result.data));
      break;
    case Fail<CheckCodeEntity?>():

      emit(CodeFailure(result.exception));
      break;
  }

  }
}
