import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Code/domain/entities/code_entities.dart';

import '../repositories/Code_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Code_useCase_repo.dart';

@Injectable(as: CodeUseCaseRepo)
class CodeUseCase implements CodeUseCaseRepo {
  final CodeRepository repository;

  CodeUseCase(this.repository);

  @override
  Future<Result<CheckCodeEntity?>> checkCode(String? code) {
  return repository.checkCode(code);
  }

  @override
  Future<Result<UseCodeEntity?>> useCode(String? code) {
return repository.useCode(code);
  }


}
