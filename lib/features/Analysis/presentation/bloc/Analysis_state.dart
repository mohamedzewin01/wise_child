part of 'Analysis_cubit.dart';

@immutable
sealed class AnalysisState {}

final class AnalysisInitial extends AnalysisState {}
final class AddViewStoryLoading extends AnalysisState {}
final class AddViewStorySuccess extends AnalysisState {
  final AddViewStoryEntity addViewStoryEntity;
  AddViewStorySuccess(this.addViewStoryEntity);
}
final class AddViewStoryFailure extends AnalysisState {
  final Exception exception;

  AddViewStoryFailure(this.exception);
}
