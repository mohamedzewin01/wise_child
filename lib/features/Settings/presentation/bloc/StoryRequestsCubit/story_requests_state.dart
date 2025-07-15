part of 'story_requests_cubit.dart';

@immutable
sealed class StoryRequestsState {}

final class StoryRequestsInitial extends StoryRequestsState {}
final class StoryRequestsLoading extends StoryRequestsState {}
final class StoryRequestsSuccess extends StoryRequestsState {
  final GetStoryRequestsRepliesEntity? getStoryRequestsEntity;
  StoryRequestsSuccess(this.getStoryRequestsEntity);
}
final class StoryRequestsFailure extends StoryRequestsState {
  final Exception exception;
  StoryRequestsFailure(this.exception);
}

