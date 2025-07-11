part of 'AllStoriesByUser_cubit.dart';

@immutable
sealed class AllStoriesByUserState {}

final class AllStoriesByUserInitial extends AllStoriesByUserState {}
final class AllStoriesByUserLoading extends AllStoriesByUserState {}
final class AllStoriesByUserSuccess extends AllStoriesByUserState {
  final UserStoriesEntity userStoriesEntity;
  AllStoriesByUserSuccess(this.userStoriesEntity);
}
final class AllStoriesByUserFailure extends AllStoriesByUserState {
  final Exception exception;

  AllStoriesByUserFailure(this.exception);
}
