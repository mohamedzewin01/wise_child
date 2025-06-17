part of 'Stories_cubit.dart';

@immutable
sealed class StoriesState {}

final class StoriesInitial extends StoriesState {}
final class StoriesLoading extends StoriesState {}
final class StoriesSuccess extends StoriesState {
  final GetChildrenEntity getChildrenEntity;

  StoriesSuccess(this.getChildrenEntity);
}
final class StoriesFailure extends StoriesState {
  final Exception exception;

  StoriesFailure(this.exception);
}

