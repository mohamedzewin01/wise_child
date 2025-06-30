part of 'SelectStoriesScreen_cubit.dart';

@immutable
sealed class SelectStoriesScreenState {}

final class SelectStoriesScreenInitial extends SelectStoriesScreenState {}
final class SelectStoriesScreenLoading extends SelectStoriesScreenState {}
final class SelectStoriesScreenSuccess extends SelectStoriesScreenState {
  final GetCategoriesStoriesEntity? getCategoriesStoriesEntity;

  SelectStoriesScreenSuccess(this.getCategoriesStoriesEntity);
}
final class SelectStoriesScreenFailure extends SelectStoriesScreenState {
  final Exception exception;

  SelectStoriesScreenFailure(this.exception);
}
