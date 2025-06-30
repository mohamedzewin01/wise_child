part of 'stories_category_cubit.dart';

@immutable
sealed class StoriesCategoryState {}

final class StoriesCategoryInitial extends StoriesCategoryState {}

final class StoriesCategoryLoading extends StoriesCategoryState {}

final class StoriesCategorySuccess extends StoriesCategoryState {
  final StoriesByCategoryEntity? storiesByCategoryEntity;

  StoriesCategorySuccess(this.storiesByCategoryEntity);
}

final class StoriesCategoryFailure extends StoriesCategoryState {
  final Exception exception;

  StoriesCategoryFailure(this.exception);
}
