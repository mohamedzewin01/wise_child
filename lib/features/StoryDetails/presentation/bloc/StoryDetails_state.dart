part of 'StoryDetails_cubit.dart';

@immutable
sealed class StoryDetailsState {}

final class StoryDetailsInitial extends StoryDetailsState {}
final class StoryDetailsLoading extends StoryDetailsState {}
final class StoryDetailsSuccess extends StoryDetailsState {
  final StoryDetailsEntity storyDetails;

  StoryDetailsSuccess(this.storyDetails);
}
final class StoryDetailsFailure extends StoryDetailsState {
  final Exception exception;

  StoryDetailsFailure(this.exception);
}
