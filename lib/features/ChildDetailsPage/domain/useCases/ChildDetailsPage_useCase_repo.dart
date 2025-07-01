import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChildDetailsPage/domain/entities/children_details_entity.dart';

abstract class ChildDetailsPageUseCaseRepo {
  Future<Result<ChildrenDetailsEntity?>> getChildDetails(int childId);
}
