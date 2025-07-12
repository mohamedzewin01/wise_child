part of 'Reports_cubit.dart';

@immutable
sealed class ReportsState {}

final class ReportsInitial extends ReportsState {}
final class ReportsLoading extends ReportsState {}
final class ReportsSuccess extends ReportsState {
  final ReportsEntity? reportsEntity;
  ReportsSuccess(this.reportsEntity);
}
final class ReportsFailure extends ReportsState {
  final Exception exception;

  ReportsFailure(this.exception);
}
