import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Code/data/models/request/check_code_request.dart';
import 'package:wise_child/features/Code/data/models/request/use_code_request.dart';

import 'package:wise_child/features/Code/data/models/response/check_code_dto.dart';

import 'package:wise_child/features/Code/data/models/response/use_code_dto.dart';
import 'package:wise_child/features/Code/domain/entities/code_entities.dart';

import 'Code_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: CodeDatasourceRepo)
class CodeDatasourceRepoImpl implements CodeDatasourceRepo {
  final ApiService apiService;

  CodeDatasourceRepoImpl(this.apiService);

  // String userId = CacheService.getData(key: CacheKeys.userId) ?? '';

  @override
  Future<Result<CheckCodeEntity?>> checkCode(String code) {
    return executeApi(() async {
      final result = await apiService.checkCode(
        CheckCodeRequest(code: code, userId: userId),
      );
      return result?.toEntity();
    });
  }

  @override
  Future<Result<UseCodeEntity?>> useCode(String code) {
    return executeApi(() async {
      final result = await apiService.useCode(
        UseCodeRequest(code: code, userId: userId),
      );
      return result?.toEntity();
    });
  }
}
