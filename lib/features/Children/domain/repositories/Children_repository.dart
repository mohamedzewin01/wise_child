import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';
import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';
import 'package:wise_child/features/Children/domain/entities/delete_entity.dart';

abstract class ChildrenRepository {
  Future<Result<GetChildrenEntity?>> getChildrenByUser();
  Future<Result<DeleteChildrenEntity?>> deleteChildren(DeleteChildrenRequest deleteChildrenRequest);
}
