part of 'Notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}
final class NotificationsLoading extends NotificationsState {}
final class NotificationsSuccess extends NotificationsState {}
final class NotificationsFailure extends NotificationsState {
  final Exception exception;

  NotificationsFailure(this.exception);
}
