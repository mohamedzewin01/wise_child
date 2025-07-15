part of 'StoriesUnderCategory_cubit.dart';

@immutable
sealed class StoriesUnderCategoryState {}

final class StoriesUnderCategoryInitial extends StoriesUnderCategoryState {}
final class StoriesUnderCategoryLoading extends StoriesUnderCategoryState {}
final class StoriesUnderCategorySuccess extends StoriesUnderCategoryState {
  final StoriesUnderCategoryEntity storiesUnderCategoryEntity;
  StoriesUnderCategorySuccess(this.storiesUnderCategoryEntity);
}
final class StoriesUnderCategoryFailure extends StoriesUnderCategoryState {
  final Exception exception;

  StoriesUnderCategoryFailure(this.exception);
}
