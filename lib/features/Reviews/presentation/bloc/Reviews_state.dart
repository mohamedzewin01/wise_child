part of 'Reviews_cubit.dart';

@immutable
sealed class ReviewsState {}

final class ReviewsInitial extends ReviewsState {}
final class AddReviewsLoading extends ReviewsState {}
final class AddReviewsSuccess extends ReviewsState {
  final AddChildReviewEntity? addReviewsEntity;
  AddReviewsSuccess(this.addReviewsEntity);
}
final class AddReviewsFailure extends ReviewsState {
  final Exception exception;

  AddReviewsFailure(this.exception);
}
final class GetReviewsLoading extends ReviewsState {}
final class GetReviewsSuccess extends ReviewsState {
  final GetChildrenReviewEntity? getReviewsEntity;
  GetReviewsSuccess(this.getReviewsEntity);
}
final class GetReviewsFailure extends ReviewsState {
  final Exception exception;

  GetReviewsFailure(this.exception);
}
