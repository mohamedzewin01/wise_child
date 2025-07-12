import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/Reviews/data/models/request/add_child_review_request.dart';
import 'package:wise_child/features/Reviews/data/models/request/get_child_review_request.dart';
import 'package:wise_child/features/Reviews/domain/entities/reviews_entities.dart';
import '../../domain/useCases/Reviews_useCase_repo.dart';

part 'Reviews_state.dart';

@injectable
class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit(this._reviewsUseCaseRepo) : super(ReviewsInitial());
  final ReviewsUseCaseRepo _reviewsUseCaseRepo;

  Future<void> addOrEditChildReview({
    required int? idChildren,
    required int? rating,
    required String? review,
  }) async {
    emit(AddReviewsLoading());
    AddChildReviewRequest addChildReviewRequest = AddChildReviewRequest(
      userId: CacheService.getData(key: CacheKeys.userId),
      idChildren: idChildren,
      rating: rating,
      reviewText: review,
    );
    var result = await _reviewsUseCaseRepo.addOrEditChildReview(
      addChildReviewRequest,
    );
    switch (result) {
      case Success<AddChildReviewEntity?>():
        {
          if (!isClosed) {
            emit(AddReviewsSuccess(result.data!));
          }
        }
        break;
      case Fail<AddChildReviewEntity?>():
        {
          if (!isClosed) {
            emit(AddReviewsFailure(result.exception));
          }
        }
        break;
    }
  }

  Future<void> getChildReview({required int? idChildren}) async {
    emit(GetReviewsLoading());
    GetChildReviewRequest addChildReviewRequest = GetChildReviewRequest(
      idChildren: idChildren,
      userId: CacheService.getData(key: CacheKeys.userId),
    );
    var result = await _reviewsUseCaseRepo.getChildReview(
      addChildReviewRequest,
    );
    switch (result) {
      case Success<GetChildrenReviewEntity?>():
        {
          if (!isClosed) {
            emit(GetReviewsSuccess(result.data!));
          }
        }
        break;
      case Fail<GetChildrenReviewEntity?>():
        {
          if (!isClosed) {
            emit(GetReviewsFailure(result.exception));
          }
        }
        break;
    }
  }
}
