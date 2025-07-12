import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Reviews/data/datasources/Reviews_datasource_repo.dart';
import 'package:wise_child/features/Reviews/data/models/request/add_child_review_request.dart';
import 'package:wise_child/features/Reviews/data/models/request/get_child_review_request.dart';
import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';
import '../../domain/repositories/Reviews_repository.dart';

@Injectable(as: ReviewsRepository)
class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsDatasourceRepo reviewsDatasourceRepo;
  ReviewsRepositoryImpl(this.reviewsDatasourceRepo);

  @override
  Future<Result<AddChildReviewEntity?>> addOrEditChildReview(AddChildReviewRequest addChildReviewRequest) {
  return reviewsDatasourceRepo.addOrEditChildReview(addChildReviewRequest);
  }

  @override
  Future<Result<GetChildrenReviewEntity?>> getChildReview(GetChildReviewRequest getChildReviewRequest) {
    return reviewsDatasourceRepo.getChildReview(getChildReviewRequest);
  }

}
