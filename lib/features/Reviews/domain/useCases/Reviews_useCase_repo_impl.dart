import 'package:wise_child/core/common/api_result.dart';

import 'package:wise_child/features/Reviews/data/models/request/add_child_review_request.dart';

import 'package:wise_child/features/Reviews/data/models/request/get_child_review_request.dart';

import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';

import '../repositories/Reviews_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Reviews_useCase_repo.dart';

@Injectable(as: ReviewsUseCaseRepo)
class ReviewsUseCase implements ReviewsUseCaseRepo {
  final ReviewsRepository repository;

  ReviewsUseCase(this.repository);

  @override
  Future<Result<AddChildReviewEntity?>> addOrEditChildReview(
    AddChildReviewRequest addChildReviewRequest,
  ) {
    return repository.addOrEditChildReview(addChildReviewRequest);
  }

  @override
  Future<Result<GetChildrenReviewEntity?>> getChildReview(
    GetChildReviewRequest getChildReviewRequest,
  ) {
    return repository.getChildReview(getChildReviewRequest);
  }
}
