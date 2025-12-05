import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Code/domain/entities/code_entities.dart';

abstract class CodeUseCaseRepo {
  Future<Result<CheckCodeEntity?>> checkCode(String? code);
  Future<Result<UseCodeEntity?>> useCode(String? code);
}
