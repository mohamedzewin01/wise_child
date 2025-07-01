part of 'ChildMode_cubit.dart';

@immutable
sealed class ChildModeState {}

final class ChildModeInitial extends ChildModeState {}
final class ChildModeLoading extends ChildModeState {}
final class ChildModeSuccess extends ChildModeState {}
final class ChildModeFailure extends ChildModeState {
  final Exception exception;

  ChildModeFailure(this.exception);
}
