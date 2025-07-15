part of 'get_home_cubit.dart';

@immutable
sealed class GetHomeState {}

final class GetHomeInitial extends GetHomeState {}
final class HomeLoading extends GetHomeState {}

final class HomeSuccess extends GetHomeState {
  final GetHomeEntity? data;
  HomeSuccess(this.data);
}

final class HomeFailure extends GetHomeState {
  final Exception exception;
  HomeFailure(this.exception);
}

final class AppStatusLoading extends GetHomeState {}

final class AppStatusSuccess extends GetHomeState {
  final AppStatusEntity? data;
  AppStatusSuccess(this.data);
}

final class AppStatusFailure extends GetHomeState {
  final Exception exception;
  AppStatusFailure(this.exception);
}
