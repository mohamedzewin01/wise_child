part of 'children_stories_cubit.dart';

@immutable
sealed class ChildrenStoriesState {}

final class ChildrenStoriesInitial extends ChildrenStoriesState {}
final class ChildrenStoriesLoading extends ChildrenStoriesState {}
final class ChildrenStoriesSuccess extends ChildrenStoriesState {
  final ChildrenStoriesModelEntity? getChildrenEntity;

  ChildrenStoriesSuccess(this.getChildrenEntity);
}
final class ChildrenStoriesFailure extends ChildrenStoriesState {
  final Exception exception;

  ChildrenStoriesFailure(this.exception);
}

final class ChildrenStoriesChildChanged extends ChildrenStoriesState {
  final int selectedChildId;

  ChildrenStoriesChildChanged(this.selectedChildId);
}