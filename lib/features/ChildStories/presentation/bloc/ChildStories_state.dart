part of 'ChildStories_cubit.dart';

@immutable
sealed class ChildStoriesState {}

final class ChildStoriesInitial extends ChildStoriesState {}
final class ChildStoriesLoading extends ChildStoriesState {}
final class ChildStoriesSuccess extends ChildStoriesState {
  final ChildStoriesEntity? getChildStoriesEntity;
  ChildStoriesSuccess(this.getChildStoriesEntity);
}
final class ChildStoriesFailure extends ChildStoriesState {
  final Exception exception;

  ChildStoriesFailure(this.exception);
}
