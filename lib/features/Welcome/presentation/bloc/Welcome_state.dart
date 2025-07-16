part of 'Welcome_cubit.dart';

@immutable
sealed class WelcomeState {}

final class WelcomeInitial extends WelcomeState {}
final class WelcomeLoading extends WelcomeState {}
final class WelcomeSuccess extends WelcomeState {}
final class WelcomeFailure extends WelcomeState {
  final Exception exception;

  WelcomeFailure(this.exception);
}
final class AppStatusLoading extends WelcomeState {}

final class AppStatusSuccess extends WelcomeState {
  final AppStatusEntity? data;
  AppStatusSuccess(this.data);
}

final class AppStatusFailure extends WelcomeState {
  final Exception exception;
  AppStatusFailure(this.exception);
}
// حالة جديدة للصيانة
final class AppMaintenanceState extends WelcomeState {
  final AppStatusEntity appStatus;
  AppMaintenanceState(this.appStatus);
}