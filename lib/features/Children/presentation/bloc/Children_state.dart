part of 'Children_cubit.dart';

@immutable
sealed class ChildrenState {}

final class ChildrenInitial extends ChildrenState {}
final class ChildrenLoading extends ChildrenState {}
final class ChildrenSuccess extends ChildrenState {
  final GetChildrenEntity getChildrenEntity;

  ChildrenSuccess(this.getChildrenEntity);
}
final class ChildrenFailure extends ChildrenState {
  final Exception exception;

  ChildrenFailure(this.exception);
}
