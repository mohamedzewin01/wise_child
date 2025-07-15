part of 'StoryInfo_cubit.dart';

@immutable
sealed class StoryInfoState {}

final class StoryInfoInitial extends StoryInfoState {}
final class StoryInfoLoading extends StoryInfoState {}
final class StoryInfoSuccess extends StoryInfoState {
  final StoryInfoEntity? storyInfoEntity;
  StoryInfoSuccess(this.storyInfoEntity);
}
final class StoryInfoFailure extends StoryInfoState {
  final Exception exception;

  StoryInfoFailure(this.exception);
}
