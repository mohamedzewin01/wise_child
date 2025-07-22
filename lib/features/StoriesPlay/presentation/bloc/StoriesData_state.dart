part of 'StoriesData_cubit.dart';

@immutable
sealed class StoriesDataState {}

final class StoriesPlayInitial extends StoriesDataState {}
final class StoriesPlayLoading extends StoriesDataState {}
final class StoriesPlaySuccess extends StoriesDataState {
  final StoryPlayEntity storyPlayEntity;

  StoriesPlaySuccess(this.storyPlayEntity);
}
final class StoriesPlayFailure extends StoriesDataState {
  final Exception exception;

  StoriesPlayFailure(this.exception);
}
