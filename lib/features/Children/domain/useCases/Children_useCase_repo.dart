import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';

abstract class ChildrenUseCaseRepo {
  Future<Result<GetChildrenEntity?>> getChildrenByUser();
}
