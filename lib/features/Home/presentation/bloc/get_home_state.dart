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
