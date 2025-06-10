part of 'directions_cubit.dart';

@immutable
sealed class DirectionsState {}

final class DirectionsInitial extends DirectionsState {}

final class DirectionsSuccess extends DirectionsState {
  final DirectionsEntity directionsEntity;
  DirectionsSuccess(this.directionsEntity);
}
final class DirectionsError extends DirectionsState {
  final Exception exception;
  DirectionsError(this.exception);
}
final class DirectionsLoading extends DirectionsState {}
