part of 'ChildDetailsPage_cubit.dart';

@immutable
sealed class ChildDetailsPageState {}

final class ChildDetailsPageInitial extends ChildDetailsPageState {}
final class ChildDetailsPageLoading extends ChildDetailsPageState {}
final class ChildDetailsPageSuccess extends ChildDetailsPageState {}
final class ChildDetailsPageFailure extends ChildDetailsPageState {
  final Exception exception;

  ChildDetailsPageFailure(this.exception);
}
