// lib/features/Auth/presentation/bloc/forgot_password_state.dart
part of 'forgot_password_cubit.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final String? email;
  
  ForgotPasswordSuccess({this.email});
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  final String? errorCode;

  ForgotPasswordFailure(this.message, {this.errorCode});
}
