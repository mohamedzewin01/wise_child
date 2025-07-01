part of 'Child_cubit.dart';

@immutable
sealed class ChildState {}

final class ChildInitial extends ChildState {}
final class ChildLoading extends ChildState {}
final class ChildSuccess extends ChildState {}
final class ChildFailure extends ChildState {
  final Exception exception;

  ChildFailure(this.exception);
}
