part of 'ChildDetailsPage_cubit.dart';

@immutable
sealed class ChildDetailsState {}

final class ChildDetailsPageInitial extends ChildDetailsState {}
final class ChildDetailsPageLoading extends ChildDetailsState {}
final class ChildDetailsPageSuccess extends ChildDetailsState {
  final ChildrenDetailsEntity childrenDetailsEntity;

  ChildDetailsPageSuccess(this.childrenDetailsEntity);
}
final class ChildDetailsPageFailure extends ChildDetailsState {
  final Exception exception;

  ChildDetailsPageFailure(this.exception);
}
