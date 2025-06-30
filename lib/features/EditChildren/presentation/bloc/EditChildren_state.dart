part of 'EditChildren_cubit.dart';

@immutable
sealed class EditChildrenState {}

final class EditChildrenInitial extends EditChildrenState {}
final class EditChildrenLoading extends EditChildrenState {}
final class EditChildrenSuccess extends EditChildrenState {}
final class EditChildrenFailure extends EditChildrenState {
  final Exception exception;

  EditChildrenFailure(this.exception);
}
