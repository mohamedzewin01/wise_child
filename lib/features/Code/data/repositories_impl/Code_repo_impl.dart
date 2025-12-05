import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Code/data/datasources/Code_datasource_repo.dart';
import 'package:wise_child/features/Code/domain/entities/code_entities.dart';
import '../../domain/repositories/Code_repository.dart';

@Injectable(as: CodeRepository)
class CodeRepositoryImpl implements CodeRepository {
  final CodeDatasourceRepo codeDatasourceRepo;
  CodeRepositoryImpl(this.codeDatasourceRepo);

  @override
  Future<Result<CheckCodeEntity?>> checkCode(String? code) {
return codeDatasourceRepo.checkCode(code);
  }

  @override
  Future<Result<UseCodeEntity?>> useCode(String? code) {
   return codeDatasourceRepo.useCode(code);
  }
  // implementation
}
