part of 'save_story_cubit.dart';

@immutable
sealed class SaveStoryState {}

final class SaveStoryInitial extends SaveStoryState {}
final class SaveStoryLoading extends SaveStoryState {}
final class SaveStorySuccess extends SaveStoryState {
  final SaveStoryEntity? getCategoriesStoriesEntity;

  SaveStorySuccess(this.getCategoriesStoriesEntity);
}
final class SaveStoryFailure extends SaveStoryState {
  final Exception exception;

  SaveStoryFailure(this.exception);
}
