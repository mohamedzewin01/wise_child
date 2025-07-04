part of 'Auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoginLoading extends AuthState {}
final class AuthLoginSuccess extends AuthState {
final  UserSignUpEntity? userEntity;
  AuthLoginSuccess(this.userEntity);
}
final class AuthLoginFailure extends AuthState {
  final Exception exception;

  AuthLoginFailure(this.exception);
}

final class AuthSingUpLoading extends AuthState {}
final class AuthSingUpSuccess extends AuthState {
  final  UserSignUpEntity? userEntity;
  AuthSingUpSuccess(this.userEntity);
}
final class AuthSingUpFailure extends AuthState {
  final Exception exception;

  AuthSingUpFailure(this.exception);
}