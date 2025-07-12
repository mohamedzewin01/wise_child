import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Reviews/data/models/request/add_child_review_request.dart';
import 'package:wise_child/features/Reviews/data/models/request/get_child_review_request.dart';
import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';

abstract class ReviewsDatasourceRepo {
  Future<Result<AddChildReviewEntity?>>addOrEditChildReview(AddChildReviewRequest addChildReviewRequest);
  Future<Result<GetChildrenReviewEntity?>>getChildReview(GetChildReviewRequest getChildReviewRequest);
}
