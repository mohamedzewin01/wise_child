part of 'user_details_cubit.dart';

@immutable
sealed class UserDetailsState {}

final class UserDetailsInitial extends UserDetailsState {}
final class UserDetailsLoading extends UserDetailsState {}
final class UserDetailsSuccess extends UserDetailsState {
  final GetUserDetailsEntity? getUserDetailsEntity;
  UserDetailsSuccess(this.getUserDetailsEntity);
}
final class UserDetailsFailure extends UserDetailsState {
  final Exception exception;
  UserDetailsFailure(this.exception);
}
