import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Reviews/data/models/request/add_child_review_request.dart';
import 'package:wise_child/features/Reviews/data/models/request/get_child_review_request.dart';

import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';

import 'Reviews_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ReviewsDatasourceRepo)
class ReviewsDatasourceRepoImpl implements ReviewsDatasourceRepo {
  final ApiService apiService;

  ReviewsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddChildReviewEntity?>> addOrEditChildReview(
    AddChildReviewRequest addChildReviewRequest,
  ) {
    return executeApi(() async {
      var response = await apiService.addChildReview(addChildReviewRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<GetChildrenReviewEntity?>> getChildReview(GetChildReviewRequest getChildReviewRequest) {
   return executeApi(() async {
     var response = await apiService.getChildReview(getChildReviewRequest);
     return response?.toEntity();
   }
   );
  }
}
