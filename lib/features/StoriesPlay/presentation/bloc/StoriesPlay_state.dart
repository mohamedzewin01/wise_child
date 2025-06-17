part of 'StoriesPlay_cubit.dart';

@immutable
sealed class StoriesPlayState {}

final class StoriesPlayInitial extends StoriesPlayState {}
final class StoriesPlayLoading extends StoriesPlayState {}
final class StoriesPlaySuccess extends StoriesPlayState {
  final StoryPlayEntity storyPlayEntity;

  StoriesPlaySuccess(this.storyPlayEntity);
}
final class StoriesPlayFailure extends StoriesPlayState {
  final Exception exception;

  StoriesPlayFailure(this.exception);
}
